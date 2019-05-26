defmodule Mtg.Api.ShowCard do
  @moduledoc """
  Module defining the getting card API call
  """

  use Mtg.Api.Base

  alias Mtg.{Card, Error}
  alias Mtg.Tools.{Transformations}

  def call(id), do: "/v1/cards/#{id}" |> get() |> wrap_data()

  defp wrap_data({_, card}), do: {:ok, Transformations.structurize_map(card, %Card{})}
  defp wrap_data(%Error{} = error), do: {:error, error}
end
