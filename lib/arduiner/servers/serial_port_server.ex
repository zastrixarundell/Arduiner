defmodule Arduiner.Servers.SerialPortServer do
  use GenServer
  alias Circuits.UART, as: Port

  def start_link(port), do: GenServer.start_link(__MODULE__, port, name: __MODULE__)

  def init(port) do
    {:ok, pid} = Port.start_link
    Port.open(pid, port, speed: 9600, active: false)
    {:ok, %{port: port, pid: pid}}
  end

  def write_message_to_port(message), do: GenServer.cast(__MODULE__, {:send_message, message})

  def handle_cast({:send_message, message}, state) do
    Port.write(state.pid, message)
    {:noreply, state}
  end

end