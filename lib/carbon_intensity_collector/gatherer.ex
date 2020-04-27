defmodule CarbonIntensityCollector.Gatherer do
  @moduledoc """
  This module provides function for the CO2 emission values acquisition.
  It performs CO2 emission gathering from configured resource in the following format:
  {
    "data": [
    {
      "from": "2020-04-27T06:30Z",
      "to": "2020-04-27T07:00Z",
      "intensity": {
        "forecast": 179,
        "actual": 176,
        "index": "moderate"
      }
    }]
  }
  Received CO2 emission value is compared with latest value in the Database and in case of  gaps,
  missed values are requested from the CO2 emission source.
  """

  require Logger

  import Ecto.Query, warn: false
  alias CarbonIntensityCollector.{Co2EmissionSchema, Repo}

  @carbon_intensity_api Application.get_env(:carbon_intensity_collector, :carbon_intensity_api)

  @spec perform_data_acquisition() :: any()
  def perform_data_acquisition do
    Logger.info("Request CO2 emission value #{inspect(DateTime.utc_now())}")

    # get latest datetime from DB
    latest_timestamp = get_latest_datetime()

    # get latest CO2 intensity from the source
    intensity = @carbon_intensity_api.get_intensity()

    # check and perform update if necessary
    check_for_updates(latest_timestamp, intensity)
  end

  defp check_for_updates(nil, current_intensity) do
    Logger.debug("First value: #{inspect(current_intensity)}}")
    insert_intensity(current_intensity)
  end

  defp check_for_updates(latest_datetime, [%{"to" => to_datetime}])
       when latest_datetime == to_datetime do
    Logger.debug("This value has been already stored, skip it")
    :noting_to_do
  end

  defp check_for_updates(latest_datetime, [%{"to" => to_datetime}]) do
    Logger.debug("Fill the gaps from #{inspect(latest_datetime)} to #{inspect(to_datetime)}")

    @carbon_intensity_api.get_intensity(latest_datetime, to_datetime)
    |> insert_intensity
  end

  defp get_latest_datetime,
    do:
      Repo.one(from(i in Co2EmissionSchema, order_by: [desc: i.id], limit: 1, select: i.datetime))

  defp insert_intensity(data) do
    Enum.map(
      data,
      fn %{"to" => datetime, "intensity" => %{"actual" => value}} ->
        %Co2EmissionSchema{}
        |> Co2EmissionSchema.changeset(%{intensity: value, datetime: datetime})
        |> Repo.insert()
      end
    )
  end
end

defmodule CarbonIntensityCollector.IntensityAPIAdapter do
  @moduledoc """
    This module suggests common API for external CO2 emission values provider
  """

  # Returns the list of decoded CO2 emission values for the specified period.
  @callback get_intensity(from :: String.t(), to :: String.t()) :: Jason.Encoder.List
end

defmodule CarbonIntensityCollector.IntensityAPIAdapter.External do
  @moduledoc """
    Implement adapter for the Official Carbon Intensity API for Great Britain
  """

  @behaviour CarbonIntensityCollector.IntensityAPIAdapter

  @co2_provider Application.get_env(:carbon_intensity_collector, :co2_provider)

  def get_intensity(from \\ "", to \\ "") do
    (@co2_provider <> from <> "/" <> to)
    |> HTTPoison.get!()
    |> Map.fetch!(:body)
    |> Jason.decode!()
    |> Map.fetch!("data")
  end
end
