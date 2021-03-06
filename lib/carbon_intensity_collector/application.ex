defmodule CarbonIntensityCollector.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias CarbonIntensityCollector.{Repo, Scheduler, Gatherer}

  def start(_type, _args) do
    children = [
      Repo,
      Scheduler,
      # perform data acquisition at start up
      {Task, fn -> Gatherer.perform_data_acquisition() end}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CarbonIntensityCollector.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
