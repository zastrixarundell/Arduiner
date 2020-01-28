defmodule Arduiner.Plugs.ArduinoPlug do
  import Plug.Conn
  alias Phoenix.Controller
  alias ArduinerWeb.Router.Helpers, as: Routes

  @moduledoc """
  This is the plug module which checks whether the Arduino is connected and 
  redirects to the connect page if it is not. 

  It uses a specific atom either `:usage` or `:create`.

  `Usage` is when the pages are where you control the Arduino and `Create` is only
  for the page where you connected to the Arduino intially.
  """

  def init(default), do: default

  @doc """
  If the Arduino is not connected redirect to the connect page.
  """
  def call(conn, :usage) do
    if !Arduiner.Servers.SerialPortServer.get_port do
      conn
      |> Controller.put_flash(:error, "You need to connect to an Arduino first!")
      |> Controller.redirect(to: Routes.arduino_path(conn, :new))
      |> halt
    else
      conn
    end
  end

  @doc """
  If the arduino is connected, you can't access the page to be connected again.
  """
  def call(conn, :create) do
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