defmodule UptimerWeb.PageController do
  use UptimerWeb, :controller

  def home(conn, _params) do
    # Use the default app layout
    render(conn, :home)
  end
end
