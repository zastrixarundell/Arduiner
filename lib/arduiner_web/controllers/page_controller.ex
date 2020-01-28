defmodule ArduinerWeb.PageController do
  use ArduinerWeb, :controller

  plug Arduiner.Plugs.ArduinoPlug, :usage

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
