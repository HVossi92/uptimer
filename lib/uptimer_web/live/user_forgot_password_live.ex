defmodule UptimerWeb.UserForgotPasswordLive do
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
                Forgot Your Password?
              </h2>
            </div>
            <div>
              <p class="text-lg sm:text-xl mb-8 text-gray-300">
                Enter your email address and we'll send you a password reset link.
              </p>
            </div>
            
    <!-- Reset Password Form -->
            <div class="w-full space-y-4 mb-8 bg-white/5 p-6 rounded-xl backdrop-blur-sm border border-white/10">
              <.form for={@form} id="reset_password_form" phx-submit="send_email" class="space-y-4">
                <div>
                  <label for="user_email" class="block text-sm font-medium text-gray-300 mb-1">
                    Email
                  </label>
                  <div class="relative rounded-md shadow-sm">
                    <input
                      type="email"
                      name="user[email]"
                      id="user_email"
                      class="block w-full rounded-md border-0 bg-white/5 py-2 px-3 text-white placeholder:text-gray-400 focus:ring-2 focus:ring-blue-500 sm:text-sm sm:leading-6"
                      placeholder="you@example.com"
                      required
                    />
                  </div>
                </div>

                <div>
                  <button
                    type="submit"
                    phx-disable-with="Sending..."
                    class="flex w-full justify-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-blue-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
                  >
                    Send password reset instructions
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

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
