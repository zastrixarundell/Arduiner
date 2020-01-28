defmodule Arduiner.Servers.SerialPortServer do
  use GenServer
  alias Circuits.UART, as: Port

  @moduledoc """
  A GenServer which represents the connection to the Arduino. The GenServer itself is always active
  as it starts a child GenServer for the Port communication. 
  """

  # Client side API

  @doc false
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @doc """
  This lets you start the communication to the port. The first argument is the name of the port
  and the second argument is the baud rate of the port. 

  It will return either `:ok` or `:error` depending on the situation.
  """
  def connect_to_port(port, rate), do: GenServer.call(__MODULE__, {:connect, port, rate})

  @doc """
  This lets you send a string to the port. It will either reply with `:ok` or `:error`.
  """
  def write_message_to_port(message), do: GenServer.call(__MODULE__, {:send_message, message})

  @doc """
  This returns the name of the conncted port.
  """
  def get_port, do: GenServer.call(__MODULE__, {:get_port})

  @doc """
  This stops the child port GenServer but not the SerialPortServer. You can't use the 
  `connect_to_port/2` at a later time again.
  """
  def stop, do: GenServer.cast(__MODULE__, {:stop_port})

  # Server code

  @doc false
  def init(_), do: {:ok, %{port: nil, pid: nil}}

  @doc false
  def handle_cast({:stop_port}, state) do
    Port.close(state.pid)
    {:noreply, %{port: nil, pid: nil}}
  end

  @doc false
  def handle_call({:send_message, message}, _from, state) do
    if !state.pid do
      {:reply, :error, state}
    else
      if Port.write(state.pid, message) == :ok do
        {:reply, :ok, state}
      else  
        {:reply, :error, state}
      end
    end
  end

  @doc false
  def handle_call({:connect, port, rate}, _from, state) do

    state =
      if state.pid do
        Port.close(state.pid)
        %{state | pid: nil}
      else
        state
      end

    {:ok, pid} = Port.start_link

    state = %{state | pid: pid}

    {rate, _} = Integer.parse(rate)

    if Port.open(state.pid, port, speed: rate, active: false) == :ok do
      {:reply, :ok, %{state | port: port}}
    else
      {:reply, :error, state}
    end
  end

  @doc false
  def handle_call({:get_port}, _from, state), do: {:reply, state.port, state}

end