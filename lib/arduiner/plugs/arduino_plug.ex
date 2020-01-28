defmodule Arduiner.Plugs.ArduinoPlug do
  import Plug.Conn
  alias Phoenix.Controller
  alias ArduinerWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, :usage) do
    IO.write "Called usage"
    if !Arduiner.Servers.SerialPortServer.get_port do
      conn
      |> Controller.put_flash(:error, "You need to connect to an Arduino first!")
      |> Controller.redirect(to: Routes.arduino_path(conn, :new))
      |> halt
    else
      conn
    end
  end

  def call(conn, :create) do
    IO.write "Called create"
    if !!Arduiner.Servers.SerialPortServer.get_port do
      conn
      |> Controller.put_flash(:error, "You need to disconnect first!")
      |> Controller.redirect(to: Routes.page_path(conn, :index))
      |> halt
    else
      conn
    end
  end

end