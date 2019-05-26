defmodule Mtg.Api.ShowSet do
  @moduledoc """
  Module defining the ligetsting set API call
  """

  use Mtg.Api.Base

  alias Mtg.{Set, Error}
  alias Mtg.Tools.{Transformations}

  def call(code), do: "/v1/sets/#{code}" |> get() |> wrap_data()

  defp wrap_data({_, set}), do: {:ok, Transformations.structurize_map(set, %Set{})}
  defp wrap_data(%Error{} = error), do: {:error, error}
end
