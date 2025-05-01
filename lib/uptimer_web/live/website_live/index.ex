defmodule UptimerWeb.WebsiteLive.Index do
  use UptimerWeb, :live_view

  alias Uptimer.Websites
  alias Uptimer.Websites.Website

  @impl true
  # def mount(_params, _session, socket) do
  def mount(params, _, %Phoenix.LiveView.Socket{} = socket) do
    # Get user ID
    user_id = socket.assigns.current_user.id

    # Stream initial websites
    websites = Websites.list_websites_for_user(user_id)

    # Get counts for limits
    website_count = Websites.count_websites_for_user(user_id)
    thumbnail_count = Websites.count_thumbnails_for_user(user_id)

    socket =
      socket
      |> stream(:websites, websites)
      |> assign(:website_count, website_count)
      |> assign(:thumbnail_count, thumbnail_count)
      # Free account limit
      |> assign(:max_websites, 32)
      # Free account limit
      |> assign(:max_thumbnails, 4)

    # Subscribe to thumbnail generation events for all websites
    if connected?(socket) do
      for website <- websites do
        Phoenix.PubSub.subscribe(Uptimer.PubSub, "website:thumbnail:#{website.id}")
      end
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Website")
    |> assign(:website, Websites.get_website!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Website")
    |> assign(:website, %Website{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Websites")
    |> assign(:website, nil)
  end

  @impl true
  def handle_info({UptimerWeb.WebsiteLive.FormComponent, {:saved, website}}, socket) do
    {:noreply, stream_insert(socket, :websites, website)}
  end

  @impl true
  def handle_info({:website_thumbnail_generated, website_id, thumbnail_url}, socket) do
    # Get the website by id
    website = Websites.get_website!(website_id)

    # Update the website in the stream with the new thumbnail
    {:noreply, stream_insert(socket, :websites, website, at: -1)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    website = Websites.get_website!(id)
    {:ok, _} = Websites.delete_website(website)

    # Unsubscribe from this website's thumbnail updates
    Phoenix.PubSub.unsubscribe(Uptimer.PubSub, "website:thumbnail:#{website.id}")

    # Update counts
    user_id = socket.assigns.current_user.id
    website_count = Websites.count_websites_for_user(user_id)
    thumbnail_count = Websites.count_thumbnails_for_user(user_id)

    {:noreply,
     socket
     |> stream_delete(:websites, website)
     |> assign(:website_count, website_count)
     |> assign(:thumbnail_count, thumbnail_count)}
  end

  @impl true
  def handle_event("toggle_thumbnail", %{"id" => id}, socket) do
    website = Websites.get_website!(id)

    case Websites.toggle_thumbnail(website) do
      {:ok, updated_website} ->
        # Update counts
        user_id = socket.assigns.current_user.id
        thumbnail_count = Websites.count_thumbnails_for_user(user_id)

        {:noreply,
         socket
         |> stream_insert(:websites, updated_website)
         |> assign(:thumbnail_count, thumbnail_count)}

      {:error, error_message} when is_binary(error_message) ->
        {:noreply, put_flash(socket, :error, error_message)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to toggle thumbnail")}
    end
  end

  @impl true
  def handle_event("refresh_thumbnail", %{"id" => id}, socket) do
    website = Websites.get_website!(id)
    {:ok, updated_website} = Websites.refresh_thumbnail(website)

    {:noreply, stream_insert(socket, :websites, updated_website)}
  end

  @impl true
  def handle_event("save", %{"website" => website_params}, socket) do
    user_id = socket.assigns.current_user.id

    case Websites.create_website(Map.put(website_params, "status", "ok"), user_id) do
      {:ok, website} ->
        # Subscribe to thumbnail updates for the new website
        Phoenix.PubSub.subscribe(Uptimer.PubSub, "website:thumbnail:#{website.id}")

        # Update counts
        website_count = Websites.count_websites_for_user(user_id)
        thumbnail_count = Websites.count_thumbnails_for_user(user_id)

        {:noreply,
         socket
         |> stream_insert(:websites, website)
         |> assign(:website_count, website_count)
         |> assign(:thumbnail_count, thumbnail_count)
         |> put_flash(:info, "Website created successfully")}

      {:error, error_message} when is_binary(error_message) ->
        {:noreply, put_flash(socket, :error, error_message)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         put_flash(socket, :error, "Error creating website: #{error_to_string(changeset)}")}
    end
  end

  defp error_to_string(changeset) do
    Enum.map(changeset.errors, fn {field, {message, _}} ->
      "#{field} #{message}"
    end)
    |> Enum.join(", ")
  end
end
