defmodule UptimerWeb.UpgradeLive do
  use UptimerWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, submitting: false, form_submitted: false)}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8 max-w-5xl">
      <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg p-6 sm:p-8">
        <h1 class="text-3xl font-bold text-center text-gray-900 dark:text-gray-100 mb-8">
          What Premium Features Would You Value?
        </h1>

        <div class="text-center mb-10">
          <p class="text-lg text-gray-700 dark:text-gray-300">
            We're exploring options to add enhanced functionality to Uptimer. To help us prioritize, what features would make a premium version worthwhile for you? Your feedback will help us shape the future of Uptimer! A premium version will also allow us to expand the current free service, while supporting continued service and development.
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
          <!-- Premium Feature Card 1 -->
          <div class="bg-blue-50 dark:bg-blue-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-blue-100 dark:bg-blue-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-globe-alt" class="h-7 w-7 text-blue-600 dark:text-blue-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Expanded Monitoring
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would a higher limit of monitored websites be valuable to you? (Currently limited to 4 in the free version)
            </p>
          </div>
          
    <!-- Premium Feature Card 2 -->
          <div class="bg-purple-50 dark:bg-purple-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-purple-100 dark:bg-purple-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-clock" class="h-7 w-7 text-purple-600 dark:text-purple-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Faster Refresh Intervals
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would you benefit from more frequent website checks? (e.g., every 2 seconds instead of the standard interval)
            </p>
          </div>
          
    <!-- Premium Feature Card 3 - Combined Visual Analytics -->
          <div class="bg-green-50 dark:bg-green-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-green-100 dark:bg-green-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-chart-bar" class="h-7 w-7 text-green-600 dark:text-green-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Visual Analytics
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would you value a visual thumbnail history with detailed performance metrics and historical uptime analytics for your websites?
            </p>
          </div>
          
    <!-- Premium Feature Card 4 -->
          <div class="bg-orange-50 dark:bg-orange-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-orange-100 dark:bg-orange-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-bell-alert" class="h-7 w-7 text-orange-600 dark:text-orange-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Advanced Notifications
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would you find value in additional notification channels like Slack, Discord, email or custom webhooks?
            </p>
          </div>
          
    <!-- Premium Feature Card 5 -->
          <div class="bg-teal-50 dark:bg-teal-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-teal-100 dark:bg-teal-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-shield-check" class="h-7 w-7 text-teal-600 dark:text-teal-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Priority Support
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would dedicated support be a valuable addition to your experience with Uptimer?
            </p>
          </div>
          
    <!-- Premium Feature Card 6 - Website Cookies & Tokens -->
          <div class="bg-indigo-50 dark:bg-indigo-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-indigo-100 dark:bg-indigo-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-key" class="h-7 w-7 text-indigo-600 dark:text-indigo-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Website Cookies & Tokens
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would you like to monitor authenticated pages by storing login cookies and tokens for your web applications?
            </p>
          </div>
          
    <!-- Premium Feature Card 7 - Organizations -->
          <div class="bg-amber-50 dark:bg-amber-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-amber-100 dark:bg-amber-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-user-group" class="h-7 w-7 text-amber-600 dark:text-amber-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Organizations
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would you benefit from team collaboration features allowing multiple users to manage and monitor websites together?
            </p>
          </div>
          
    <!-- Premium Feature Card 8 - API Access -->
          <div class="bg-cyan-50 dark:bg-cyan-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-cyan-100 dark:bg-cyan-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-code-bracket-square" class="h-7 w-7 text-cyan-600 dark:text-cyan-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              API Access
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Would an API to access monitoring data from third-party applications and integrate with your systems be valuable?
            </p>
          </div>
          
    <!-- Premium Feature Card 9 - Other Features -->
          <div class="bg-rose-50 dark:bg-rose-900/20 rounded-xl p-6 shadow-sm hover:shadow-md transition-shadow">
            <div class="bg-rose-100 dark:bg-rose-800/30 p-3 rounded-xl inline-block mb-4">
              <.icon name="hero-sparkles" class="h-7 w-7 text-rose-600 dark:text-rose-400" />
            </div>
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-3">
              Other Features
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Do you have other ideas for premium features that would make Uptimer more valuable to you? Share them in the form below!
            </p>
          </div>
        </div>
        
    <!-- Premium Interest Form -->
        <div class={@form_submitted && "hidden"}>
          <div class="bg-gray-100 dark:bg-gray-700/40 rounded-xl p-6 sm:p-8 shadow-inner">
            <h2 class="text-2xl font-bold text-gray-800 dark:text-gray-200 mb-4 text-center">
              Share Your Feedback
            </h2>
            <p class="text-gray-600 dark:text-gray-400 mb-6 text-center">
              Your input will help us understand which premium features would be most valuable to our users.
              No commitment required - we're just gathering feedback at this stage.
            </p>

            <form
              phx-submit="submit_interest"
              phx-change="form_changed"
              class="space-y-6 max-w-2xl mx-auto"
            >
              <div class="space-y-4">
                <div>
                  <label
                    for="email"
                    class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
                  >
                    Email Address
                  </label>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="your@email.com"
                    required
                    class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800 dark:text-gray-100"
                  />
                </div>

                <div>
                  <label
                    for="features"
                    class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
                  >
                    Which potential features would interest you most? (Select all that apply)
                  </label>
                  <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 mt-2">
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input
                        type="checkbox"
                        name="features[]"
                        value="expanded_monitoring"
                        class="mt-1"
                      />
                      <span class="text-gray-700 dark:text-gray-300">Expanded Monitoring</span>
                    </label>
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input type="checkbox" name="features[]" value="faster_refresh" class="mt-1" />
                      <span class="text-gray-700 dark:text-gray-300">Faster Refresh Intervals</span>
                    </label>
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input type="checkbox" name="features[]" value="visual_analytics" class="mt-1" />
                      <span class="text-gray-700 dark:text-gray-300">Visual Analytics</span>
                    </label>
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input
                        type="checkbox"
                        name="features[]"
                        value="advanced_notifications"
                        class="mt-1"
                      />
                      <span class="text-gray-700 dark:text-gray-300">Advanced Notifications</span>
                    </label>
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input type="checkbox" name="features[]" value="priority_support" class="mt-1" />
                      <span class="text-gray-700 dark:text-gray-300">Priority Support</span>
                    </label>
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input
                        type="checkbox"
                        name="features[]"
                        value="website_cookies_tokens"
                        class="mt-1"
                      />
                      <span class="text-gray-700 dark:text-gray-300">Website Cookies & Tokens</span>
                    </label>
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input type="checkbox" name="features[]" value="organizations" class="mt-1" />
                      <span class="text-gray-700 dark:text-gray-300">Organizations</span>
                    </label>
                    <label class="flex items-start space-x-2 cursor-pointer">
                      <input type="checkbox" name="features[]" value="api_access" class="mt-1" />
                      <span class="text-gray-700 dark:text-gray-300">API Access</span>
                    </label>
                  </div>
                </div>

                <div>
                  <label
                    for="price_willing"
                    class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
                  >
                    If we offered these features, what monthly price would you consider fair? (€)
                  </label>
                  <select
                    id="price_willing"
                    name="price_willing"
                    class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800 dark:text-gray-100"
                  >
                    <option value="">Select a price range</option>
                    <option value="not_interested">Not interested in premium features</option>
                    <option value="1_5">€4 - €9 per month</option>
                    <option value="6_10">€10 - €19 per month</option>
                    <option value="11_15">€20 - €39 per month</option>
                    <option value="16_20">€40 - €99 per month</option>
                    <option value="21_plus">€99+ per month</option>
                  </select>
                </div>

                <div>
                  <label
                    for="feature_request"
                    class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
                  >
                    What other features would make Uptimer more valuable to you?
                  </label>
                  <textarea
                    id="feature_request"
                    name="feature_request"
                    rows="3"
                    placeholder="Share your ideas for potential premium features..."
                    class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-800 dark:text-gray-100"
                  ></textarea>
                </div>
              </div>

              <div class="flex justify-center">
                <button
                  type="submit"
                  disabled={@submitting}
                  class={
                    "px-6 py-3 text-white font-medium rounded-lg shadow-sm transition-all " <>
                    if @submitting do
                      "bg-blue-400 dark:bg-blue-500 cursor-not-allowed"
                    else
                      "bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-600 hover:shadow-md"
                    end
                  }
                >
                  <%= if @submitting do %>
                    <div class="flex items-center justify-center">
                      <svg
                        class="animate-spin -ml-1 mr-2 h-4 w-4 text-white"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                      >
                        <circle
                          class="opacity-25"
                          cx="12"
                          cy="12"
                          r="10"
                          stroke="currentColor"
                          stroke-width="4"
                        >
                        </circle>
                        <path
                          class="opacity-75"
                          fill="currentColor"
                          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                        >
                        </path>
                      </svg>
                      <span>Submitting...</span>
                    </div>
                  <% else %>
                    Submit Feedback
                  <% end %>
                </button>
              </div>
            </form>
          </div>
        </div>
        
    <!-- Thank you message (shown after submission) -->
        <div class={!@form_submitted && "hidden"}>
          <div class="p-6 bg-green-50 dark:bg-green-900/20 rounded-lg text-center">
            <.icon
              name="hero-check-circle"
              class="h-12 w-12 text-green-600 dark:text-green-400 mx-auto mb-4"
            />
            <h3 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">
              Thank You for Your Feedback!
            </h3>
            <p class="text-gray-600 dark:text-gray-400">
              Your input is invaluable in helping us determine if and how we should develop premium features.
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("form_changed", _params, socket) do
    # Reset submitting state if the user changes any form fields
    {:noreply, assign(socket, :submitting, false)}
  end

  def handle_event("submit_interest", params, socket) do
    # Set submitting state to true
    socket = assign(socket, :submitting, true)

    # Log the feedback data for debugging
    IO.inspect(params, label: "Premium Feature Feedback")

    # Send the feedback email
    case send_feedback_email(params) do
      {:ok, _} ->
        # Success message if email sent
        socket =
          socket
          |> put_flash(
            :info,
            "Thank you for your feedback! We've received your input and will notify you about premium features."
          )
          |> assign(:form_submitted, true)

        {:noreply, socket}

      {:error, reason} ->
        # Error message if email failed
        IO.inspect(reason, label: "Email Error")

        socket =
          put_flash(
            socket,
            :error,
            "Thank you for your feedback! We've recorded your input but there was an issue sending the confirmation email."
          )

        # Keep the submitting state as true since we don't want to allow multiple submissions on error
        {:noreply, socket}
    end
  end

  defp send_feedback_email(params) do
    import Swoosh.Email
    alias Uptimer.Mailer

    # Get admin email (same as used for sending emails)
    admin_email = System.get_env("GMAIL_USERNAME") || "noreply@example.com"

    # Format the selected features
    selected_features =
      (params["features"] || [])
      |> Enum.map(fn feature ->
        case feature do
          "expanded_monitoring" -> "Expanded Monitoring"
          "faster_refresh" -> "Faster Refresh Intervals"
          "visual_analytics" -> "Visual Analytics"
          "advanced_notifications" -> "Advanced Notifications"
          "priority_support" -> "Priority Support"
          "website_cookies_tokens" -> "Website Cookies & Tokens"
          "organizations" -> "Organizations"
          "api_access" -> "API Access"
          _ -> feature
        end
      end)
      |> Enum.join(", ")

    # Format price range
    price_range =
      case params["price_willing"] do
        "not_interested" -> "Not interested in premium features"
        "1_5" -> "€1 - €5 per month"
        "6_10" -> "€6 - €10 per month"
        "11_15" -> "€11 - €15 per month"
        "16_20" -> "€16 - €20 per month"
        "21_plus" -> "€21+ per month"
        "" -> "No selection"
        _ -> params["price_willing"]
      end

    # Create email body
    email_body = """
    Premium Feature Feedback Submission

    From: #{params["email"]}

    Interested Features: #{if selected_features == "", do: "None selected", else: selected_features}

    Price Range: #{price_range}

    Additional Feature Requests:
    #{if params["feature_request"] == "", do: "None provided", else: params["feature_request"]}

    Submitted at: #{DateTime.utc_now() |> DateTime.to_string()}
    """

    # Create email
    email =
      new()
      |> to(admin_email)
      |> from({"Uptimer Premium Feedback", admin_email})
      |> subject("New Premium Feature Feedback from #{params["email"]}")
      |> text_body(email_body)

    # Send the email and return the result
    Mailer.deliver(email)
  end
end
