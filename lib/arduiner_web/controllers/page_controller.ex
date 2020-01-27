defmodule ArduinerWeb.PageController do
  use ArduinerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
