defmodule ArduinerWeb.ArduinoController do
  use ArduinerWeb, :controller
  alias Arduiner.Servers.SerialPortServer, as: Server

  use Supervisor

  def create(conn, opts) do
    %{"selection" => selection} = opts
    %{"port" => port, "rate" => rate} = selection

    response =
      if Server.connect_to_port(port, rate) == :ok,
        do: %{ atom: :info, message: "Started SPS on #{port}!"},
        else: %{ atom: :error, message: "Failed to start SPS on #{port}!"}
      
    conn
    |> put_flash(response.atom, response.message)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def delete(conn, _params) do
    Server.stop

    conn
    |> put_flash(:info, "Disconnected the Arduino controller")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end