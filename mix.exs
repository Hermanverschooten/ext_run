defmodule ExtRun.Mixfile do
  use Mix.Project

  def project do
    [app: :ext_run,
     version: "0.1.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:elixir_make] ++ Mix.compilers,
     make_clean: ["clean"],
     package: package(),
     deps: deps(),
     description: description()
   ]
  end

  def description do
    """
    Small tool to run external process from elixir that is not owned by the BEAM
    """
  end

  def package do
    [
      maintainers: ["Herman verschooten"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Hermanverschooten/ext_run"},
      files: ["lib", "src/*.[ch]", "mix.exs", "README.md", "LICENSE", "Makefile"]
    ]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.4", runtime: false},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev}
    ]
  end
end
