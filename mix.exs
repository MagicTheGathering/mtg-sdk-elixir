defmodule Mtg.MixProject do
  use Mix.Project

  def project() do
    [
      app: :mtg,
      version: "0.1.3",
      elixir: "~> 1.8",
      name: "MTG SDK Elixir",
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/MagicTheGathering/mtg-sdk-elixir",
      docs: [
        main: "readme",
        extras: [
          "README.md",
          "CHANGELOG.md"
        ]
      ],
      test_coverage: [tool: ExCoveralls, test_task: "espec"],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test, espec: :test],
      spec_paths: ["spec"],
      spec_pattern: "*_spec.exs",
      dialyzer: [
        plt_add_deps: :transitive,
        flags: [
          # "-Wunmatched_returns",
          # "-Wrace_conditions",
          # "-Wunderspecs",
          # "-Wunknown",
          # "-Woverspecs",
          # "-Wspecdiffs",
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:dialyxir, "~> 0.5", only: :dev},
      {:espec, "~> 1.7.0", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.20.2", only: :dev},
      {:httpoison, "~> 1.4"},
      {:inflex, "~> 1.10"},
      {:jason, "~> 1.1"}
    ]
  end

  defp description() do
    "SDK for using https://magicthegathering.io/ in Elixir."
  end

  defp package() do
    [
      maintainers: ["Adrian Santalla Romero de Ávila", "Alexander Moreno Borrego", "Mario Garrido Torres"],
      licenses: ["MIT"],
      links: %{
        Changelog: "https://github.com/MagicTheGathering/mtg-sdk-elixir/blob/master/CHANGELOG.md",
        GitHub: "https://github.com/MagicTheGathering/mtg-sdk-elixir"
      }
    ]
  end
end
