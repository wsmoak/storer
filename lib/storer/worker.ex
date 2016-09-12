defmodule Storer.Worker do
  require Logger
  use GenServer
  use Timex

  @timezone "America/New_York"

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

    time = Timex.now # time in UTC
    PersistentStorage.put last_fed_at: time

    Process.send_after(self, :get_it, 1000)
    {:noreply, state}
  end

  def handle_info(:get_it, state) do
    Logger.debug "Getting something!"
    val = PersistentStorage.get :key
    Logger.debug inspect(val)

    time = PersistentStorage.get :last_fed_at
    Logger.debug inspect(time)

    tz = Timezone.get(@timezone, time)
    time_in_timezone = Timezone.convert(time, tz)
    Logger.debug inspect(time_in_timezone)

    Process.send_after(self, :store_it, 5000)
    {:noreply, state}
  end
end
