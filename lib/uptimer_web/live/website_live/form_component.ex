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
        <div class="text-sm text-gray-600 mt-1 mb-4">
          You can enter URLs with or without http(s):// prefix and with or without www
          (e.g., example.com, www.example.com, or https://example.com)
        </div>
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:thumbnail]} type="checkbox" label="Use thumbnail instead of iframe" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Website</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{website: website, current_user: current_user} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_user, current_user)
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
    user_id = socket.assigns.current_user.id

    case Websites.update_website(socket.assigns.website, website_params, user_id: user_id) do
      {:ok, website} ->
        notify_parent({:saved, website})

        {:noreply,
         socket
         |> put_flash(:info, "Website updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}

      {:error, error_message} when is_binary(error_message) ->
        {:noreply,
         socket
         |> put_flash(:error, error_message)
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp save_website(socket, :new, website_params) do
    user_id = socket.assigns.current_user.id

    case Websites.create_website(website_params, user_id) do
      {:ok, website} ->
        notify_parent({:saved, website})

        {:noreply,
         socket
         |> put_flash(:info, "Website created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}

      {:error, error_message} when is_binary(error_message) ->
        changeset =
          socket.assigns.website
          |> Websites.change_website(website_params)
          |> Map.put(:action, :validate)
          |> Map.put(:errors, address: {"#{error_message}", []})

        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
