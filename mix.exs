defmodule CarbonIntensityCollector.MixProject do
  use Mix.Project

  def project do
    [
      app: :carbon_intensity_collector,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CarbonIntensityCollector.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.6"},
      {:quantum, "~> 2.3"}
    ]
  end
end
