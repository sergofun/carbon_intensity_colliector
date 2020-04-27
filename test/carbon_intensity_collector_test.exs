defmodule CarbonIntensityCollectorTest do
  use ExUnit.Case
  import Ecto.Query, warn: false

  alias CarbonIntensityCollector.{Repo, Gatherer, Co2EmissionSchema}

  doctest CarbonIntensityCollector.Gatherer

  setup context do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CarbonIntensityCollector.Repo)
    Process.put(:test, context[:test])
    context
  end

  test "first value" do
    Gatherer.perform_data_acquisition()
    assert Repo.aggregate(Co2EmissionSchema, :count) == 1
  end

  test "the same value" do
    Gatherer.perform_data_acquisition()
    assert Repo.aggregate(Co2EmissionSchema, :count) == 1
    Gatherer.perform_data_acquisition()
    assert Repo.aggregate(Co2EmissionSchema, :count) == 1
  end

  test "malformed response" do
    Gatherer.perform_data_acquisition()
    assert Repo.aggregate(Co2EmissionSchema, :count) == 0
  end

  test "filling the gaps" do
    Process.put(:test, :"test filling the gaps phase1")
    Gatherer.perform_data_acquisition()
    assert Repo.aggregate(Co2EmissionSchema, :count) == 1

    Process.put(:test, :"test filling the gaps phase2")
    Gatherer.perform_data_acquisition()
    assert Repo.aggregate(Co2EmissionSchema, :count) == 2
  end
end

defmodule CarbonIntensityCollector.IntensityAPIAdapter.Dummy do
  @moduledoc false
  @behaviour CarbonIntensityCollector.IntensityAPIAdapter

  def extract_value(%{"to" => datetime, "intensity" => %{"actual" => value}}) do
    %{intensity: value, datetime: datetime}
  end

  def extract_value(_) do
    %{}
  end

  def get_intensity(), do: get_intensity(nil, nil)

  def get_intensity(_from, _to) do
    generate_intensity_data(Process.get(:test))
  end

  defp generate_intensity_data(test)
       when test == :"test first value" or
              test == :"test the same value" or
    test == :"test filling the gaps phase1" do
    [
      %{
        "from" => "2020-04-27T08:30Z",
        "to" => "2020-04-27T09:00Z",
        "intensity" => %{
          "forecast" => 152,
          "actual" => 150,
          "index" => "low"
        }
      }
    ]
  end

  defp generate_intensity_data(:"test malformed response") do
    [%{"from" => "2020-04-27T08:30Z", "to" => "2020-04-27T09:00Z", "intensity" => 999}]
  end

#  defp generate_intensity_data(:"test filling the gaps phase1") do
#    [
#      %{
#        "from" => "2020-04-27T09:00Z",
#        "to" => "2020-04-27T09:30Z",
#        "intensity" => %{
#          "forecast" => 152,
#          "actual" => 150,
#          "index" => "low"
#        }
#      }
#    ]
#  end

  defp generate_intensity_data(:"test filling the gaps phase2") do
    [
      %{
        "from" => "2020-04-27T09:00Z",
        "to" => "2020-04-27T09:30Z",
        "intensity" => %{
          "forecast" => 152,
          "actual" => 150,
          "index" => "low"
        }
      },
      %{
        "from" => "2020-04-27T09:30Z",
        "to" => "2020-04-27T10:00Z",
        "intensity" => %{
          "forecast" => 152,
          "actual" => 150,
          "index" => "low"
        }
      }
    ]
  end
end
