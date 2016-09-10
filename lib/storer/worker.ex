defmodule Storer.Worker do
  require Logger
  use GenServer

  # Client

  def start_link(path) do
    GenServer.start_link(__MODULE__, [path], name: StorerWorker)
  end

  # Server Callbacks

  def init(path) do
    Logger.debug "The path is #{path}"
    :ok = PersistentStorage.setup path: path
    Process.send_after(self, :store_it, 1000)
    {:ok, %{}}
  end

  def handle_info(:store_it, state) do
    Logger.debug "Storing something!"
    :ok = PersistentStorage.put :key, {2,3,4}
    Process.send_after(self, :get_it, 1000)
    {:noreply, state}
  end

  def handle_info(:get_it, state) do
    Logger.debug "Getting something!"
    val = PersistentStorage.get :key
    Logger.debug inspect(val)
    {:noreply, state}
  end
end
