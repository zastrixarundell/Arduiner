defmodule ArduinerWeb.LedController do
  use ArduinerWeb, :controller
  alias Arduiner.Servers.SerialPortServer, as: Server

  def create(conn, _params) do
    Server.write_message_to_port("start")
    conn
    |> put_flash(:info, "Started LED on the Arduino!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete(conn, _params) do
    Server.write_message_to_port("stop")
    conn
    |> put_flash(:info, "Stopped LED on the Arduino!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
  