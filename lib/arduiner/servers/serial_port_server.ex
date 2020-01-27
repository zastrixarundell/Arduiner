defmodule Arduiner.Servers.SerialPortServer do
    use GenServer

    def start_link(port), do: GenServer.start_link(__MODULE__, [port])

    def init(port) do
        IO.puts "Starting server on port"
        {:ok, port}
    end

end