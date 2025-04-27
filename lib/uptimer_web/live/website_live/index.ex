defmodule UptimerWeb.WebsiteLive.Index do
  use UptimerWeb, :live_view

  alias Uptimer.Websites
  alias Uptimer.Websites.Website

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :websites, Websites.list_websites())}
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
  def handle_event("delete", %{"id" => id}, socket) do
    website = Websites.get_website!(id)
    {:ok, _} = Websites.delete_website(website)

    {:noreply, stream_delete(socket, :websites, website)}
  end
end
