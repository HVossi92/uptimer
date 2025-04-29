defmodule UptimerWeb.Router do
  use UptimerWeb, :router

  import UptimerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {UptimerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UptimerWeb do
    pipe_through :browser

    # Use HomeLive for the root path with the custom home layout
    live_session :home,
      layout: {UptimerWeb.Layouts, :home},
      on_mount: [{UptimerWeb.UserAuth, :mount_current_user}] do
      live "/", HomeLive, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", UptimerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:uptimer, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: UptimerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", UptimerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      layout: {UptimerWeb.Layouts, :home},
      on_mount: [{UptimerWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      # live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", UptimerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{UptimerWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/websites", WebsiteLive.Index, :index
      live "/websites/new", WebsiteLive.Index, :new
      live "/websites/:id/edit", WebsiteLive.Index, :edit
      live "/websites/:id", WebsiteLive.Show, :show
      live "/websites/:id/show/edit", WebsiteLive.Show, :edit
    end
  end

  scope "/", UptimerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      layout: {UptimerWeb.Layouts, :home},
      on_mount: [{UptimerWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
