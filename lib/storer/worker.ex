defmodule Storer.Worker do
  require Logger
  use GenServer

  def start_link(path) do
    GenServer.start_link(__MODULE__, [path], name: StorerWorker)
  end

  # Server Callbacks

  def init(path) do
    Logger.debug "The path is #{path}"
    {:ok, %{}}
  end
end
