defmodule Arduiner.Servers.SerialPortServer do
  use GenServer
  alias Circuits.UART, as: Port

  # Client side API

  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def write_message_to_port(message), do: GenServer.call(__MODULE__, {:send_message, message})

  def get_port, do: GenServer.call(__MODULE__, {:get_port})

  def connect_to_port(port), do: GenServer.call(__MODULE__, {:connect, port})

  def stop, do: GenServer.cast(__MODULE__, {:stop_port})

  # Server code

  def init(_), do: {:ok, %{port: nil, pid: nil}}

  def handle_cast({:stop_port}, state) do
    Port.close(state.pid)
    {:noreply, %{port: nil, pid: nil}}
  end

  def handle_call({:send_message, message}, _from, state) do
    if Port.write(state.pid, message) == :ok do
      {:reply, :ok, state}
    else  
      {:reply, :error, state}
    end
  end

  def handle_call({:connect, port}, _from, state) do

    state =
      if state.pid do
        Port.close(state.pid)
        %{state | pid: nil}
      else
        state
      end

    {:ok, pid} = Port.start_link

    state = %{state | pid: pid}

    if Port.open(state.pid, port, speed: 9600, active: false) == :ok do
      {:reply, :ok, %{state | port: port}}
    else
      {:reply, :error, state}
    end
  end

  def handle_call({:get_port}, _from, state), do: {:reply, Map.get(state, :port), state}

end