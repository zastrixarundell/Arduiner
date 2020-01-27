defmodule ArduinerWeb.PageController do
  use ArduinerWeb, :controller
  alias Arduiner.Servers.SerialPortServer, as: Server

  def index(conn, _params) do
    render(conn, "index.html", port: Server.get_port)
  end
end
