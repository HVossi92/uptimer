defmodule UptimerWeb.WebsiteLive.Show do
  use UptimerWeb, :live_view

  alias Uptimer.Websites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user_id = socket.assigns.current_user.id

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:website, Websites.get_website_for_user!(id, user_id))}
  end

  defp page_title(:show), do: "Show Website"
  defp page_title(:edit), do: "Edit Website"
end
