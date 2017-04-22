defmodule ExtRun.Mixfile do
  use Mix.Project

  def project do
    [app: :ext_run,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:elixir_make] ++ Mix.compilers,
     make_clean: ["clean"],
     package: package(),
     deps: deps()]
  end

  def package do
    [
      maintainers: ["Herman verschooten"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Hermanverschooten/ext_run"}
    ]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.4", runtime: false}
    ]
  end
end
