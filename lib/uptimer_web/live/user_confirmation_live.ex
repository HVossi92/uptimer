defmodule UptimerWeb.UserConfirmationLive do
  use UptimerWeb, :live_view

  alias Uptimer.Accounts

  def render(%{live_action: :edit} = assigns) do
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
                Confirm Account
              </h2>
            </div>
            <div>
              <p class="text-lg sm:text-xl mb-8 text-gray-300">
                Click the button below to confirm your account.
              </p>
            </div>
            
    <!-- Confirmation Form -->
            <div class="w-full space-y-4 mb-8 bg-white/5 p-6 rounded-xl backdrop-blur-sm border border-white/10">
              <.form for={@form} id="confirmation_form" phx-submit="confirm_account" class="space-y-4">
                <input type="hidden" name={@form[:token].name} value={@form[:token].value} />

                <div>
                  <button
                    type="submit"
                    phx-disable-with="Confirming..."
                    class="flex w-full justify-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-blue-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
                  >
                    Confirm my account
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

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/users/log_in")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
