defmodule UptimerWeb.WebsiteLive.FormComponent do
  use UptimerWeb, :live_component

  alias Uptimer.Websites

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage website records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="website-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:status]} type="text" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Website</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{website: website} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Websites.change_website(website))
     end)}
  end

  @impl true
  def handle_event("validate", %{"website" => website_params}, socket) do
    changeset = Websites.change_website(socket.assigns.website, website_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"website" => website_params}, socket) do
    save_website(socket, socket.assigns.action, website_params)
  end

  defp save_website(socket, :edit, website_params) do
    case Websites.update_website(socket.assigns.website, website_params) do
      {:ok, website} ->
        notify_parent({:saved, website})

        {:noreply,
         socket
         |> put_flash(:info, "Website updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_website(socket, :new, website_params) do
    case Websites.create_website(website_params) do
      {:ok, website} ->
        notify_parent({:saved, website})

        {:noreply,
         socket
         |> put_flash(:info, "Website created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
