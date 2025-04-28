defmodule UptimerWeb.UserLoginLive do
  use UptimerWeb, :live_view

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
                Welcome Back
              </h2>
            </div>
            <div>
              <p class="text-lg sm:text-xl mb-8 text-gray-300">
                Log in to your account to access your dashboard and manage your websites.
              </p>
            </div>
            
    <!-- Login Form -->
            <div class="w-full space-y-4 mb-8 bg-white/5 p-6 rounded-xl backdrop-blur-sm border border-white/10">
              <.form
                for={@form}
                id="login_form"
                action={~p"/users/log_in"}
                phx-update="ignore"
                class="space-y-4"
              >
                <div>
                  <label for="user_email" class="block text-sm font-medium text-gray-300 mb-1">
                    Email
                  </label>
                  <div class="relative rounded-md shadow-sm">
                    <input
                      type="email"
                      name="user[email]"
                      id="user_email"
                      value={@form[:email].value}
                      class="block w-full rounded-md border-0 bg-white/5 py-2 px-3 text-white placeholder:text-gray-400 focus:ring-2 focus:ring-blue-500 sm:text-sm sm:leading-6"
                      placeholder="you@example.com"
                      required
                    />
                  </div>
                </div>

                <div>
                  <label for="user_password" class="block text-sm font-medium text-gray-300 mb-1">
                    Password
                  </label>
                  <div class="relative rounded-md shadow-sm">
                    <input
                      type="password"
                      name="user[password]"
                      id="user_password"
                      class="block w-full rounded-md border-0 bg-white/5 py-2 px-3 text-white placeholder:text-gray-400 focus:ring-2 focus:ring-blue-500 sm:text-sm sm:leading-6"
                      placeholder="••••••••"
                      required
                    />
                  </div>
                </div>

                <div class="flex items-center justify-between mt-2">
                  <div class="flex items-center">
                    <input
                      id="user_remember_me"
                      name="user[remember_me]"
                      type="checkbox"
                      class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                    />
                    <label for="user_remember_me" class="ml-2 block text-sm text-gray-300">
                      Remember me
                    </label>
                  </div>
                  <div class="text-sm">
                    <.link
                      navigate={~p"/users/reset_password"}
                      class="font-semibold text-blue-400 hover:text-blue-300"
                    >
                      Forgot password?
                    </.link>
                  </div>
                </div>

                <div>
                  <button
                    type="submit"
                    phx-disable-with="Logging in..."
                    class="flex w-full justify-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-blue-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
                  >
                    Log in
                  </button>
                </div>

                <div class="text-center mt-4">
                  <p class="text-sm text-gray-300">
                    Don't have an account?
                    <.link
                      navigate={~p"/users/register"}
                      class="font-semibold text-blue-400 hover:text-blue-300 ml-1"
                    >
                      Sign up
                    </.link>
                  </p>
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
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
