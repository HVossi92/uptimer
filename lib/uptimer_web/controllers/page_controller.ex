defmodule UptimerWeb.PageController do
  use UptimerWeb, :controller

  def home(conn, _params) do
    # Redirect if the user is already logged in
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: ~p"/websites")
    else
      # Use the home layout without header and footer
      conn
      |> put_layout({UptimerWeb.Layouts, :home})
      |> render(:home)
    end
  end
end
