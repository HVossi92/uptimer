defmodule Uptimer.Repo do
  use Ecto.Repo,
    otp_app: :uptimer,
    adapter: Ecto.Adapters.SQLite3
end
