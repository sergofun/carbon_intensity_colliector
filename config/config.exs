import Config

config :carbon_intensity_collector,
       ecto_repos: [CarbonIntensityCollector.Repo]

config :carbon_intensity_collector,
  co2_provider: "https://api.carbonintensity.org.uk/intensity/"

config :carbon_intensity_collector, CarbonIntensityCollector.Repo,
  database: "carbon_intensity_collector_repo",
  username: "postgres",
  password: "password",
  hostname: "localhost"

config :logger, :console,
       format: "$time $metadata[$level] $message\n",
       metadata: [:request_id],
       handle_otp_reports: true,
       handle_sasl_reports: true

config :carbon_intensity_collector, :carbon_intensity_api,
       CarbonIntensityCollector.IntensityAPIAdapter.External

config :carbon_intensity_collector, CarbonIntensityCollector.Scheduler,
       debug_logging: false,
       global: false,
       jobs: [
         {"*/30 * * * *",  {CarbonIntensityCollector.Gatherer, :perform_data_acquisition, []}},
       ]

import_config "#{Mix.env}.exs"
