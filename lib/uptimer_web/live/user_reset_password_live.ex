defmodule UptimerWeb.UserResetPasswordLive do
  use UptimerWeb, :live_view

  alias Uptimer.Accounts

  def render(assigns) do
    ~H"""
    <!-- Main Content -->
    <div
      class="min-h-screen flex items-center justify-center"
      style="background: radial-gradient(circle at center, #1E40AF, #000000);"
    >
      <div class="bg-pattern"></div>
      <div class="content w-full">
        <div class="w-full max-w-xl mx-auto p-8 flex flex-col justify-between min-h-screen">
          <!-- Header Section -->
          <div class="flex-1 flex flex-col justify-center items-center text-center">
            <div>
              <h2 class="text-4xl sm:text-5xl font-extrabold mb-4 bg-clip-text text-transparent bg-gradient-to-br from-gray-200 to-gray-600">
                Reset Your Password
              </h2>
            </div>
            <div>
              <p class="text-lg sm:text-xl mb-8 text-gray-300">
                Enter your new password below to complete the reset process.
              </p>
            </div>
            
    <!-- Reset Password Form -->
            <div class="w-full space-y-4 mb-8 bg-white/5 p-6 rounded-xl backdrop-blur-sm border border-white/10">
              <.form
                for={@form}
                id="reset_password_form"
                phx-submit="reset_password"
                phx-change="validate"
                class="space-y-4"
              >
                <.error :if={@form.errors != []} class="text-red-400 text-sm mb-4">
                  Oops, something went wrong! Please check the errors below.
                </.error>

                <div>
                  <label for="user_password" class="block text-sm font-medium text-gray-300 mb-1">
                    New Password
                  </label>
                  <div class="relative rounded-md shadow-sm">
                    <input
                      type="password"
                      name="user[password]"
                      id="user_password"
                      value={@form[:password].value}
                      class={[
                        "block w-full rounded-md border-0 bg-white/5 py-2 px-3 text-white placeholder:text-gray-400 focus:ring-2 focus:ring-blue-500 sm:text-sm sm:leading-6",
                        @form[:password].errors != [] && "ring-1 ring-red-500 focus:ring-red-500"
                      ]}
                      placeholder="••••••••"
                      required
                    />
                    <div class="text-red-400 text-xs mt-1">
                      {@form[:password].errors |> Enum.map(fn {msg, _} -> msg end) |> Enum.join(", ")}
                    </div>
                  </div>
                </div>

                <div>
                  <label
                    for="user_password_confirmation"
                    class="block text-sm font-medium text-gray-300 mb-1"
                  >
                    Confirm New Password
                  </label>
                  <div class="relative rounded-md shadow-sm">
                    <input
                      type="password"
                      name="user[password_confirmation]"
                      id="user_password_confirmation"
                      value={@form[:password_confirmation].value}
                      class={[
                        "block w-full rounded-md border-0 bg-white/5 py-2 px-3 text-white placeholder:text-gray-400 focus:ring-2 focus:ring-blue-500 sm:text-sm sm:leading-6",
                        @form[:password_confirmation].errors != [] &&
                          "ring-1 ring-red-500 focus:ring-red-500"
                      ]}
                      placeholder="••••••••"
                      required
                    />
                    <div class="text-red-400 text-xs mt-1">
                      {@form[:password_confirmation].errors
                      |> Enum.map(fn {msg, _} -> msg end)
                      |> Enum.join(", ")}
                    </div>
                  </div>
                </div>

                <div>
                  <button
                    type="submit"
                    phx-disable-with="Resetting..."
                    class="flex w-full justify-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-blue-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
                  >
                    Reset Password
                  </button>
                </div>

                <div class="flex justify-between items-center mt-4 text-sm text-gray-300">
                  <.link
                    navigate={~p"/users/register"}
                    class="font-semibold text-blue-400 hover:text-blue-300"
                  >
                    Register
                  </.link>
                  <.link
                    navigate={~p"/users/log_in"}
                    class="font-semibold text-blue-400 hover:text-blue-300"
                  >
                    Log in
                  </.link>
                </div>
              </.form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      // Dark mode functionality
      const html = document.documentElement;

      // Check for saved theme preference or use system preference
      const savedTheme = localStorage.getItem('theme');
      if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        html.classList.add('dark');
      } else {
        html.classList.remove('dark');
      }
    </script>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_user_and_token(socket, _params) do
    socket
    |> put_flash(:error, "Reset password link is invalid or it has expired.")
    |> redirect(to: ~p"/")
  end
end
