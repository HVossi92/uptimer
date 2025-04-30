defmodule UptimerWeb.UserSettingsLive do
  use UptimerWeb, :live_view

  alias Uptimer.Accounts

  def render(assigns) do
    ~H"""
    <div class="h-full bg-gradient-radial-light dark:bg-gradient-radial-dark">
      <div class="content w-full py-8">
        <div class="container mx-auto px-4 sm:px-6">
          <.header class="text-center mb-8">
            <h1 class="text-gray-900 dark:text-white">Account Settings</h1>
            <:subtitle>
              <span class="text-gray-600 dark:text-gray-300">
                Manage your account email address and password settings
              </span>
            </:subtitle>
          </.header>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <!-- Email Settings -->
            <div class="bg-white/90 dark:bg-gray-800/30 backdrop-blur-sm rounded-xl shadow-xl overflow-hidden p-6 border border-gray-200 dark:border-white/20">
              <h3 class="font-bold text-gray-800 dark:text-white text-lg mb-4">Email Settings</h3>
              <.simple_form
                for={@email_form}
                id="email_form"
                phx-submit="update_email"
                phx-change="validate_email"
                class="space-y-4"
              >
                <.input
                  field={@email_form[:email]}
                  type="email"
                  label="Email"
                  required
                  class="block w-full px-4 py-2.5 bg-white/50 dark:bg-black/20 border border-gray-300 dark:border-white/20 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
                />
                <.input
                  field={@email_form[:current_password]}
                  name="current_password"
                  id="current_password_for_email"
                  type="password"
                  label="Current password"
                  value={@email_form_current_password}
                  required
                  class="block w-full px-4 py-2.5 bg-white/50 dark:bg-black/20 border border-gray-300 dark:border-white/20 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
                />
                <:actions>
                  <.button
                    phx-disable-with="Changing..."
                    class="w-full px-4 py-2.5 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 dark:hover:bg-blue-500 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
                  >
                    Change Email
                  </.button>
                </:actions>
              </.simple_form>
            </div>
            
    <!-- Password Settings -->
            <div class="bg-white/90 dark:bg-gray-800/30 backdrop-blur-sm rounded-xl shadow-xl overflow-hidden p-6 border border-gray-200 dark:border-white/20">
              <h3 class="font-bold text-gray-800 dark:text-white text-lg mb-4">Password Settings</h3>
              <.simple_form
                for={@password_form}
                id="password_form"
                action={~p"/users/log_in?_action=password_updated"}
                method="post"
                phx-change="validate_password"
                phx-submit="update_password"
                phx-trigger-action={@trigger_submit}
                class="space-y-4 bg-transparent"
              >
                <input
                  name={@password_form[:email].name}
                  type="hidden"
                  id="hidden_user_email"
                  value={@current_email}
                />
                <.input
                  field={@password_form[:password]}
                  type="password"
                  label="New password"
                  required
                  class="block w-full px-4 py-2.5 bg-white/50 dark:bg-black/20 border border-gray-300 dark:border-white/20 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
                />
                <.input
                  field={@password_form[:password_confirmation]}
                  type="password"
                  label="Confirm new password"
                  class="block w-full px-4 py-2.5 bg-white/50 dark:bg-black/20 border border-gray-300 dark:border-white/20 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
                />
                <.input
                  field={@password_form[:current_password]}
                  name="current_password"
                  type="password"
                  label="Current password"
                  id="current_password_for_password"
                  value={@current_password}
                  required
                  class="block w-full px-4 py-2.5 bg-white/50 dark:bg-black/20 border border-gray-300 dark:border-white/20 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
                />
                <:actions>
                  <.button
                    phx-disable-with="Changing..."
                    class="w-full px-4 py-2.5 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 dark:hover:bg-blue-500 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
                  >
                    Change Password
                  </.button>
                </:actions>
              </.simple_form>
            </div>
            
    <!-- Delete Account -->
            <div class="md:col-span-2 bg-white/90 dark:bg-gray-800/30 backdrop-blur-sm rounded-xl shadow-xl overflow-hidden p-6 border border-gray-200 dark:border-white/20 mt-4">
              <h3 class="font-bold text-gray-800 dark:text-white text-lg mb-4">Danger Zone</h3>
              <.simple_form
                id="delete_user_form"
                for={%{}}
                phx-submit="delete_user"
                class="mt-4 bg-transparent"
                data-confirm="Are you sure you want to delete your account? This action cannot be undone."
              >
                <div class="flex flex-col items-start gap-4">
                  <p class="text-sm text-gray-700 dark:text-gray-300">
                    This will permanently delete your account, all of your websites, and associated data. This action cannot be undone.
                  </p>
                  <.button
                    class="px-4 py-2.5 text-sm font-medium text-white bg-red-600 hover:bg-red-700 dark:hover:bg-red-500 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors flex items-center"
                    phx-disable-with="Deleting..."
                  >
                    <.icon name="hero-trash" class="h-5 w-5 mr-2" /> Delete Account
                  </.button>
                </div>
              </.simple_form>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("delete_user", _params, socket) do
    user = socket.assigns.current_user

    case Accounts.delete_user(user) do
      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "Account deleted successfully.")
         |> redirect(to: ~p"/")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error deleting account: #{inspect(reason)}")
         |> redirect(to: ~p"/users/settings")}
    end
  end
end
