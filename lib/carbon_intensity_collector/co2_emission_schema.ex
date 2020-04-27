defmodule CarbonIntensityCollector.Co2EmissionSchema do
  @moduledoc """
  Defines schema for co2_emission table and changeset for adding emission value
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "co2_emission" do
    field(:intensity, :integer)
    field(:datetime, :string)
  end

  @spec changeset(intention :: Ecto.Schema.t(), params :: Keyword.t()) :: Ecto.Changeset.t()
  def changeset(intention, params) do
    intention
    |> cast(params, __MODULE__.__schema__(:fields))
    |> validate_required([:intensity, :datetime])
  end
end
