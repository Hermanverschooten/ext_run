defmodule Updater do
  @on_load {:init, 0}

  @moduledoc """
    Simple NIF that allows execution of independent OS processes
  """


  def init() do
    path = :filename.join(:code.priv_dir(:updater), 'updater_nif')
    case :erlang.load_nif(path, 0) do
      :ok -> :ok
      error -> {:error, error}
    end
  end

  def run(_cmd) do
    raise "NIF run/1 not implemented"
  end
end
