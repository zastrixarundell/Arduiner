defmodule Arduiner.Servers.SerialPortServer do
  use GenServer
  alias Circuits.UART, as: Port

  def start_link(port), do: GenServer.start_link(__MODULE__, port, name: __MODULE__)

  def init(port) do
    IO.write "Starting UART GenServer\n"
    {:ok, pid} = Port.start_link
    IO.write "Started UART GenServer on "; IO.inspect pid;
    IO.write "Starting serial on #{port}\n"
    Port.open(pid, port, speed: 9600, active: false)
    IO.write "Started serial on #{port}\n"
    {:ok, {port, pid}}
  end

  def write_message_to_port(message), do: GenServer.cast(__MODULE__, {:send_message, message})

  def handle_cast({:send_message, message}, state) do
    {port, pid} = state
    Port.write(pid, message)
    {:noreply, state}
  end

end