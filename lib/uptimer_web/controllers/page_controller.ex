defmodule UptimerWeb.PageController do
  use UptimerWeb, :controller

  def home(conn, _params) do
    # Use the home layout without header and footer
    conn
    |> put_layout({UptimerWeb.Layouts, :home})
    |> render(:home)
  end
end
