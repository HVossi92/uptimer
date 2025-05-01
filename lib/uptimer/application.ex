defmodule Uptimer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UptimerWeb.Telemetry,
      Uptimer.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:uptimer, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:uptimer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Uptimer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Uptimer.Finch},
      # Start to serve requests, typically the last entry
      UptimerWeb.Endpoint
    ]

    # Setup thumbnail directory
    Uptimer.Websites.Thumbnail.init()

    # Ensure ChromicPDF is included in the supervision tree
    children =
      if Application.get_env(:uptimer, :include_chromic_pdf, true) do
        children ++ [ChromicPDF]
      else
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Uptimer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UptimerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # Always run migrations in all environments
    false
  end
end
