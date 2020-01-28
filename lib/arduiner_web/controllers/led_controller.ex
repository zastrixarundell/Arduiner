defmodule ArduinerWeb.LedController do
  use ArduinerWeb, :controller
  alias Arduiner.Servers.SerialPortServer, as: Server

  def create(conn, _params) do

    response =
      if Server.write_message_to_port("start") == :ok,
        do: %{atom: :info, message: "Started the LED on the Arduino!"},
        else: %{atom: :error, message: "Failed to start the LED on the Arduino!"}

    conn
    |> put_flash(response.atom, response.message)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete(conn, _params) do

    response =
      if Server.write_message_to_port("stop") == :ok,
        do: %{atom: :info, message: "Stopped the LED on the Arduino!"},
        else: %{atom: :error, message: "Failed to stop the LED on the Arduino!"}

    conn
    |> put_flash(response.atom, response.message)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
  