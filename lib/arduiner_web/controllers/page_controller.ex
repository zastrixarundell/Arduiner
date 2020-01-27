defmodule ArduinerWeb.PageController do
  use ArduinerWeb, :controller
  alias Arduiner.Servers.SerialPortServer, as: Server

  def index(conn, _params) do
    all_data = Circuits.UART.enumerate

    ports =
      Enum.map all_data, fn({name, data}) -> name end

    render(conn, "index.html", ports: ports)
  end
end
