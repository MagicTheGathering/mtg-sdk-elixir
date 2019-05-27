defmodule Mtg.Api.GenerateSetBooster do
  @moduledoc """
  Module defining the booster API call for a set
  """

  use Mtg.Api.Base

  alias Mtg.{Card, Error}
  alias Mtg.Response.{Collection}
  alias Mtg.Tools.{Transformations}

  def call(code), do: "/v1/sets/#{code}/booster" |> get() |> wrap_data()

  defp wrap_data({headers, data}) do
    {
      :ok,
      %Collection{
        type: "cards",
        data: data |> handle_structure([]),
        page_size: Transformations.add_number_header_value(headers, "Page-Size"),
        count: Transformations.add_number_header_value(headers, "Count"),
        total_count: Transformations.add_number_header_value(headers, "Total-Count")
      }
    }
  end
  defp wrap_data(%Error{} = error), do: {:error, error}

  defp handle_structure([], acc), do: Enum.reverse(acc)
  defp handle_structure([card | remaining_cards], acc),
    do: handle_structure(remaining_cards, [Transformations.structurize_map(card, %Card{}) | acc])
end
