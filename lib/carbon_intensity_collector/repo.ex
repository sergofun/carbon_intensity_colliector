defmodule CarbonIntensityCollector.Repo do
  @moduledoc """
  Carbon intensity collector repository
  """

  use Ecto.Repo,
    otp_app: :carbon_intensity_collector,
    adapter: Ecto.Adapters.Postgres
end
