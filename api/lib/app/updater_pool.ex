defmodule App.UpdaterPool do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    poolboy_config = [
      name: {:local, :updater_pool},
      worker_module: App.Updater,
      size: 10,
      max_overflow: 1
    ]

    children = [
      :poolboy.child_spec(:updater_pool, poolboy_config, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
