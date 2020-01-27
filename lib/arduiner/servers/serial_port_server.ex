defmodule Arduiner.Servers.SerialPortServer do
  use GenServer
  alias Circuits.UART, as: Port

  # Client side API

  def start_link(port), do: GenServer.start_link(__MODULE__, port, name: __MODULE__)

  def write_message_to_port(message), do: GenServer.cast(__MODULE__, {:send_message, message})

  def get_port, do: GenServer.call(__MODULE__, {:get_port})

  # Server code

  def init(port) do
    {:ok, pid} = Port.start_link
    if Port.open(pid, port, speed: 9600, active: false) == :ok do
      {:ok, %{port: port, pid: pid}}
    else
      {:stop, "Failed to start the port #{port}"}
    end
  end

  def handle_cast({:send_message, message}, state) do
    case Port.write(state.pid, message) do
      {:error, _} ->
        {:stop, :port_unavailable, state}
      :ok ->  
        {:noreply, state}
    end
  end

  def handle_call({:get_port}, _from, state), do: {:reply, state.port, state}

end