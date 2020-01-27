defmodule ArduinerWeb.LedController do
  use ArduinerWeb, :controller
  alias Arduiner.Servers.SerialPortServer, as: Server

  def create(conn, _params) do
    enabled = Server.write_message_to_port("start")

    response =
      if enabled == :ok do
        %{
          atom: :info,
          message: "Started the LED on the Arduino!"
        }
      else
        %{
          atom: :error,
          message: "Failed to start the LED on the Arduino!"
        }
      end 

    conn
    |> put_flash(response.atom, response.message)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete(conn, _params) do
    enabled = Server.write_message_to_port("stop")

    response =
      if enabled == :ok do
        %{
          atom: :info,
          message: "Stopped the LED on the Arduino!"
        }
      else
        %{
          atom: :error,
          message: "Failed to stop the LED on the Arduino!"
        }
      end 

    conn
    |> put_flash(response.atom, response.message)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
  