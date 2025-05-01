defmodule Uptimer.Websites do
  @moduledoc """
  The Websites context.
  """

  import Ecto.Query, warn: false
  alias Uptimer.Repo

  alias Uptimer.Websites.Website
  alias Uptimer.Websites.Thumbnail

  @doc """
  Returns the list of websites.

  ## Examples

      iex> list_websites()
      [%Website{}, ...]

  """
  def list_websites do
    Repo.all(Website)
  end

  def list_websites_for_user(user_id) do
    Repo.all(from w in Website, where: w.user_id == ^user_id)
  end

  @doc """
  Counts the number of websites for a given user.
  """
  def count_websites_for_user(user_id) do
    Repo.one(from w in Website, where: w.user_id == ^user_id, select: count(w.id))
  end

  @doc """
  Counts the number of websites with thumbnails enabled for a given user.
  """
  def count_thumbnails_for_user(user_id) do
    Repo.one(
      from w in Website, where: w.user_id == ^user_id and w.thumbnail == true, select: count(w.id)
    )
  end

  @doc """
  Gets a single website.

  Raises `Ecto.NoResultsError` if the Website does not exist.

  ## Examples

      iex> get_website!(123)
      %Website{}

      iex> get_website!(456)
      ** (Ecto.NoResultsError)

  """
  def get_website!(id), do: Repo.get!(Website, id)

  @doc """
  Gets a single website for a specific user.
  Ensures that the website belongs to the user making the request.

  Raises `Ecto.NoResultsError` if the Website does not exist or doesn't belong to the user.

  ## Examples

      iex> get_website_for_user!(123, user_id)
      %Website{}

      iex> get_website_for_user!(456, user_id)
      ** (Ecto.NoResultsError)
  """
  def get_website_for_user!(id, user_id) do
    Website
    |> where([w], w.id == ^id and w.user_id == ^user_id)
    |> Repo.one!()
  end

  @doc """
  Creates a website.

  ## Examples

      iex> create_website(%{field: value})
      {:ok, %Website{}}

      iex> create_website(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(attrs \\ %{}, user_id) do
    # Check if the user has reached the maximum number of websites (32)
    if count_websites_for_user(user_id) >= 32 do
      {:error, "Maximum number of websites (32) reached for free accounts"}
    else
      # Normalize the address before making the request
      address = normalize_url(attrs["address"])
      attrs = Map.put(attrs, "address", address)

      # Try to make a request to the website, but handle possible connection errors
      request_result =
        try do
          secure_result = make_secure_request(address)

          case secure_result do
            {:ok, _} = response ->
              response

            # If secure request fails, try with insecure options
            {:error, %Mint.TransportError{reason: {:tls_alert, _}}} ->
              # This is likely a certificate issue, try with insecure options
              make_insecure_request(address)

            error ->
              error
          end
        rescue
          error ->
            IO.inspect(error, label: "Error in create_website")
            {:error, :invalid_url}
        catch
          error ->
            IO.inspect(error, label: "Caught in create_website")
            {:error, :timeout}
        end

      # Process the request results
      case request_result do
        {:ok, response} ->
          # Successfully connected to the website
          attrs = Map.put(attrs, "status", Integer.to_string(response.status))
          # Add user_id to the attributes
          attrs = Map.put(attrs, "user_id", user_id)

          # Set thumbnail to false by default to prevent automatic enabling
          # Users will need to explicitly enable thumbnails
          attrs = Map.put_new(attrs, "thumbnail", false)

          result =
            %Website{}
            |> Website.changeset(attrs)
            |> Repo.insert()

          case result do
            {:ok, website} ->
              # Generate thumbnail asynchronously if thumbnail is enabled
              # However, this should now be false by default
              if website.thumbnail do
                Task.start(fn -> generate_and_save_thumbnail(website) end)
              end

              result

            error ->
              error
          end

        {:error, %Mint.TransportError{reason: reason}} ->
          # Handle specific transport errors
          error_message =
            case reason do
              :nxdomain ->
                "Domain not found. Please check the URL."

              :timeout ->
                "Connection timed out. Website might be unavailable."

              :econnrefused ->
                "Connection refused. Website might be unavailable."

              :closed ->
                "Connection closed unexpectedly."

              {:tls_alert, _} ->
                "SSL certificate error. If this is an IP address with HTTPS, try using HTTP instead."

              _ ->
                "Error connecting to website: #{inspect(reason)}"
            end

          {:error, error_message}

        {:error, %Mint.HTTPError{}} ->
          {:error, "Invalid HTTP response from website"}

        {:error, _} ->
          {:error, "Could not connect to website. Please check the URL."}
      end
    end
  end

  @doc """
  Updates a website.

  ## Examples

      iex> update_website(website, %{field: new_value})
      {:ok, %Website{}}

      iex> update_website(website, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_website(%Website{} = website, attrs, opts \\ []) do
    # Ensure the caller owns this website
    unless opts[:skip_ownership_check] do
      # If user_id is provided and doesn't match the website's user_id, return error
      if Map.has_key?(opts, :user_id) && website.user_id != opts[:user_id] do
        {:error, "You don't have permission to update this website"}
      else
        # Continue with the update
        do_update_website(website, attrs, opts)
      end
    else
      # Skip ownership check and continue with the update
      do_update_website(website, attrs, opts)
    end
  end

  # Internal function to handle the actual update
  defp do_update_website(%Website{} = website, attrs, opts) do
    # If address is being updated, normalize it first
    attrs =
      if Map.has_key?(attrs, "address") do
        Map.put(attrs, "address", normalize_url(attrs["address"]))
      else
        attrs
      end

    request_result =
      secure_result = make_secure_request(website.address)

    case secure_result do
      {:ok, _} = response ->
        response

      # If secure request fails, try with insecure options
      {:error, %Mint.TransportError{reason: {:tls_alert, _}}} ->
        # This is likely a certificate issue, try with insecure options
        make_insecure_request(website.address)

      error ->
        error
    end

    {:ok, response} = request_result
    attrs = Map.put(attrs, "status", Integer.to_string(response.status))

    result =
      website
      |> Website.changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, updated_website} ->
        unless Keyword.get(opts, :skip_thumbnail_update, false) do
          handle_thumbnail_update(website, updated_website, response)
        end

        result

      error ->
        error
    end
  end

  # Handle thumbnail updates based on various conditions
  defp handle_thumbnail_update(website, updated_website, response) do
    thumbnail_enabled = website.thumbnail
    is_success_status = response.status < 400

    cond do
      # Case 1: Generate thumbnail when enabled/toggled and status is good
      thumbnail_enabled && is_success_status ->
        Task.start(fn -> generate_and_save_thumbnail(updated_website) end)

      # Case 2: Delete thumbnail when status code indicates error
      response.status >= 400 ->
        Thumbnail.delete_thumbnails_for_url(website.address)

      # Case 3: No action needed
      true ->
        :ok
    end
  end

  @doc """
  Updates a website by checking its status without changing other attributes.

  ## Examples

      iex> update_website(website)
      {:ok, %Website{}}
  """
  def update_website(%Website{} = website) do
    IO.puts("Refreshing thumbnail for #{website.address}")
    # Get current website status
    request_result =
      secure_result = make_secure_request(website.address)

    case secure_result do
      {:ok, _} = response ->
        response

      # If secure request fails, try with insecure options
      {:error, %Mint.TransportError{reason: {:tls_alert, _}}} ->
        # This is likely a certificate issue, try with insecure options
        make_insecure_request(website.address)

      error ->
        error
    end

    # Handle the request result
    case request_result do
      {:ok, response} ->
        # Only update the status attribute
        update_website(website, %{"status" => Integer.to_string(response.status)})

      {:error, %Mint.TransportError{reason: :nxdomain}} ->
        # Domain doesn't exist - set status to "dns_error"
        update_website(website, %{"status" => "dns_error"})

      {:error, _} ->
        # Other errors - set status to generic error
        update_website(website, %{"status" => "error"})
    end
  end

  @doc """
  Deletes a website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%Website{} = website, opts \\ []) do
    # Ensure the caller owns this website
    if Map.has_key?(opts, :user_id) && website.user_id != opts[:user_id] do
      {:error, "You don't have permission to delete this website"}
    else
      # Delete all thumbnails for this website
      Thumbnail.delete_thumbnails_for_url(website.address)

      # Delete the website from database
      Repo.delete(website)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> change_website(website)
      %Ecto.Changeset{data: %Website{}}

  """
  def change_website(%Website{} = website, attrs \\ %{}) do
    Website.changeset(website, attrs)
  end

  @doc """
  Toggles the thumbnail preference for a website.

  ## Examples

      iex> toggle_thumbnail(website)
      {:ok, %Website{}}
  """
  def toggle_thumbnail(%Website{} = website, opts \\ []) do
    # Ensure the caller owns this website
    if Map.has_key?(opts, :user_id) && website.user_id != opts[:user_id] do
      {:error, "You don't have permission to modify this website"}
    else
      # If toggling from false to true, check the thumbnail limit
      if !website.thumbnail do
        # Check if user already has 4 thumbnails
        if count_thumbnails_for_user(website.user_id) >= 4 do
          {:error, "Maximum number of thumbnails (4) reached for free accounts"}
        else
          update_website(
            website,
            %{
              "thumbnail" => true
            },
            skip_ownership_check: true
          )
        end
      else
        # Disabling a thumbnail is always allowed
        update_website(
          website,
          %{
            "thumbnail" => false
          },
          skip_ownership_check: true
        )
      end
    end
  end

  def refresh_thumbnail(%Website{} = website, opts \\ []) do
    # Ensure the caller owns this website
    if Map.has_key?(opts, :user_id) && website.user_id != opts[:user_id] do
      {:error, "You don't have permission to refresh thumbnails for this website"}
    else
      # First delete existing thumbnails to force a fresh generation
      Thumbnail.delete_thumbnails_for_url(website.address)

      # Then generate a new thumbnail
      case generate_and_save_thumbnail(website) do
        {:ok, updated_website} -> {:ok, updated_website}
        {:error, _} = error -> error
      end
    end
  end

  @doc """
  Deletes a website's thumbnail and updates the record.

  ## Examples

      iex> delete_thumbnail(website)
      {:ok, %Website{}}
  """
  def delete_thumbnail(%Website{} = website, opts \\ []) do
    # Ensure the caller owns this website
    if Map.has_key?(opts, :user_id) && website.user_id != opts[:user_id] do
      {:error, "You don't have permission to modify thumbnails for this website"}
    else
      # Delete thumbnail files
      Thumbnail.delete_thumbnails_for_url(website.address)

      # Update website record to remove thumbnail_url
      result =
        update_website(website, %{"thumbnail_url" => nil},
          skip_thumbnail_update: true,
          skip_ownership_check: true
        )

      # Broadcast that thumbnail has been removed
      case result do
        {:ok, updated_website} ->
          Phoenix.PubSub.broadcast(
            Uptimer.PubSub,
            "website:thumbnail:#{updated_website.id}",
            {:website_thumbnail_generated, updated_website.id, nil}
          )

        _ ->
          :ok
      end

      result
    end
  end

  @doc """
  Generates and saves a thumbnail for a website.
  """
  def generate_and_save_thumbnail(%Website{} = website) do
    case Thumbnail.generate_thumbnail(website.address) do
      {:ok, thumbnail_url} ->
        IO.puts("Thumbnail generated for #{website.address}")

        # Update the website with the new thumbnail URL, but skip thumbnail update to prevent recursion
        result =
          update_website(website, %{"thumbnail_url" => thumbnail_url},
            skip_thumbnail_update: true
          )

        # Broadcast event that thumbnail has been generated
        Phoenix.PubSub.broadcast(
          Uptimer.PubSub,
          "website:thumbnail:#{website.id}",
          {:website_thumbnail_generated, website.id, thumbnail_url}
        )

        result

      {:error, _reason} ->
        # Delete any existing thumbnails for this URL
        Thumbnail.delete_thumbnails_for_url(website.address)

        # Set the thumbnail_url to nil if thumbnail is enabled
        if website.thumbnail do
          result = update_website(website, %{"thumbnail_url" => nil}, skip_thumbnail_update: true)

          # Broadcast that we're using the default "no preview" image
          Phoenix.PubSub.broadcast(
            Uptimer.PubSub,
            "website:thumbnail:#{website.id}",
            {:website_thumbnail_generated, website.id, nil}
          )

          result
        else
          # Just log error and continue
          {:error, :thumbnail_generation_failed}
        end
    end
  end

  # Add browser-like headers to help with sites using bot protection
  defp add_browser_headers(request) do
    url =
      "#{request.scheme}://#{request.host}#{if request.port not in [80, 443], do: ":#{request.port}", else: ""}#{request.path}"

    Finch.build(
      request.method,
      url,
      [
        {"User-Agent",
         "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"},
        {"Accept",
         "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"},
        {"Accept-Language", "en-US,en;q=0.5"},
        {"Accept-Encoding", "gzip, deflate, br"},
        {"Connection", "keep-alive"},
        {"Upgrade-Insecure-Requests", "1"},
        {"Sec-Fetch-Dest", "document"},
        {"Sec-Fetch-Mode", "navigate"},
        {"Sec-Fetch-Site", "none"},
        {"Sec-Fetch-User", "?1"},
        {"Cache-Control", "max-age=0"}
      ],
      request.body
    )
  end

  # Utility function to normalize URLs for connections
  def normalize_url(nil), do: nil

  def normalize_url(url) do
    # Trim whitespace
    url = String.trim(url)

    # Check if it's an IP address
    is_ip_address = Regex.match?(~r/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(:\d+)?$/, url)

    # Only strip www. if it's not an IP address
    url =
      if !is_ip_address && Regex.match?(~r/^www\./i, url) do
        String.replace(url, ~r/^www\./i, "")
      else
        url
      end

    # Add https:// prefix if no protocol specified
    if Regex.match?(~r/^https?:\/\//i, url) do
      # Also strip www. from URLs with http/https if not an IP address
      if !is_ip_address && Regex.match?(~r/^https?:\/\/www\./i, url) do
        String.replace(url, ~r/^(https?:\/\/)www\./i, "\\1")
      else
        url
      end
    else
      "https://#{url}"
    end
  end

  # Make a request with normal certificate validation
  defp make_secure_request(url) do
    Finch.build(:get, url)
    |> add_browser_headers()
    |> Finch.request(Uptimer.Finch, receive_timeout: 10_000)
  end

  # Make a request with insecure certificate validation for self-signed or invalid certs
  defp make_insecure_request(url) do
    # Try HTTP if HTTPS fails with certificate errors
    insecure_url =
      if String.starts_with?(url, "https://") do
        String.replace(url, "https://", "http://")
      else
        url
      end

    Finch.build(:get, insecure_url)
    |> add_browser_headers()
    |> Finch.request(Uptimer.Finch, receive_timeout: 10_000)
  end
end
