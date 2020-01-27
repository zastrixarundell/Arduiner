defmodule Arduiner.Servers.SerialPortServer do
    use GenServer
    alias Circuits.UART, as: Port

    def start_link(port), do: GenServer.start_link(__MODULE__, port)

    def init(port) do
        IO.write "Starting UART GenServer\n"
        {:ok, pid} = Port.start_link
        IO.write "Started UART GenServer on "; IO.inspect pid;
        IO.write "Starting serial on #{port}\n"
        Port.open(pid, port, speed: 9600, active: false)
        IO.write "Started serial on #{port}\n"
        {:ok, {port, pid}}
    end

end