defmodule Arduiner.Servers.SerialPortServer do
  use GenServer
  alias Circuits.UART, as: Port

  # Client side API

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def write_message_to_port(message), do: GenServer.cast(__MODULE__, {:send_message, message})

  def get_port, do: GenServer.call(__MODULE__, {:get_port})

  def connect_to_port(port), do: GenServer.call(__MODULE__, {:connect, port})

  # Server code

  def init(_) do
    {:ok, pid} = Port.start_link
    {:ok, %{pid: pid}}
  end

  def handle_cast({:send_message, message}, state) do
    case Port.write(state.pid, message) do
      {:error, _} ->
        {:stop, :port_unavailable, state}
      :ok ->  
        {:noreply, state}
    end
  end

  def handle_call({:connect, port}, _from, state) do
    if Port.open(state.pid, port, speed: 9600, active: false) == :ok do
      {:reply, :ok, Map.put(state, :port, port)}
    else
      {:reply, :error, state}
    end
  end

  def handle_call({:get_port}, _from, state), do: {:reply, state.port, state}

end