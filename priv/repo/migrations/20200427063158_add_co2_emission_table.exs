defmodule CarbonIntensityCollector.Repo.Migrations.AddCo2EmissionTable do
  use Ecto.Migration

  def change do
    create table(:co2_emission) do
      add :intensity, :integer
      add :datetime, :string
    end
  end
end
