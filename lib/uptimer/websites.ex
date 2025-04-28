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
  Creates a website.

  ## Examples

      iex> create_website(%{field: value})
      {:ok, %Website{}}

      iex> create_website(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(attrs \\ %{}) do
    {:ok, response} =
      Finch.build(:get, attrs["address"])
      |> add_browser_headers()
      |> Finch.request(Uptimer.Finch)

    attrs = Map.put(attrs, "status", Integer.to_string(response.status))

    result =
      %Website{}
      |> Website.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, website} ->
        # Generate thumbnail asynchronously
        Task.start(fn -> generate_and_save_thumbnail(website) end)
        result

      error ->
        error
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
  def update_website(%Website{} = website, attrs) do
    {:ok, response} =
      Finch.build(:get, website.address)
      |> add_browser_headers()
      |> Finch.request(Uptimer.Finch)

    attrs = Map.put(attrs, "status", Integer.to_string(response.status))

    result =
      website
      |> Website.changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, updated_website} ->
        # If thumbnail was enabled, generate thumbnail
        if Map.get(attrs, "thumbnail") && website.thumbnail != updated_website.thumbnail &&
             response.status < 400 do
          Task.start(fn -> generate_and_save_thumbnail(updated_website) end)
        else
          if response.status >= 400 do
            Thumbnail.delete_thumbnails_for_url(website.address)
          end
        end

        result

      error ->
        error
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
    {:ok, response} =
      Finch.build(:get, website.address)
      |> add_browser_headers()
      |> Finch.request(Uptimer.Finch)

    # Only update the status attribute
    update_website(website, %{"status" => Integer.to_string(response.status)})
  end

  @doc """
  Deletes a website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%Website{} = website) do
    # Delete all thumbnails for this website
    Thumbnail.delete_thumbnails_for_url(website.address)

    # Delete the website from database
    Repo.delete(website)
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
  def toggle_thumbnail(%Website{} = website) do
    update_website(website, %{
      "thumbnail" => !website.thumbnail
    })
  end

  def refresh_thumbnail(%Website{} = website) do
    update_website(website)
  end

  @doc """
  Generates and saves a thumbnail for a website.
  """
  def generate_and_save_thumbnail(%Website{} = website) do
    case Thumbnail.generate_thumbnail(website.address) do
      {:ok, thumbnail_url} ->
        IO.puts("Thumbnail generated for #{website.address}")
        # Update the website with the new thumbnail URL
        result = update_website(website, %{"thumbnail_url" => thumbnail_url})

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
          result = update_website(website, %{"thumbnail_url" => nil})

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
end
