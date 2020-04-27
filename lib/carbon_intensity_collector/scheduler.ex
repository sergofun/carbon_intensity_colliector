defmodule CarbonIntensityCollector.Scheduler do
  @moduledoc """
    Quantum scheduler for periodic CO2 emission requesting
  """
  use Quantum.Scheduler,
      otp_app: :carbon_intensity_collector
end