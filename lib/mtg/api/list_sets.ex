defmodule Mtg.Api.ListSets do
  @moduledoc """
  Module defining the listing sets API call
  """

  use Mtg.Api.Base

  alias Mtg.{Set, Error}
  alias Mtg.Request.{Query}
  alias Mtg.Response.{Collection}
  alias Mtg.Tools.{Transformations}

  def call(query_params),
    do: "/v1/sets" |> Query.build_path(query_params) |> get() |> wrap_data()

  defp wrap_data({headers, data}) do
    {
      :ok,
      %Collection{
        type: "sets",
        data: data |> handle_structure([]),
        page_size: Transformations.add_number_header_value(headers, "Page-Size"),
        count: Transformations.add_number_header_value(headers, "Count"),
        total_count: Transformations.add_number_header_value(headers, "Total-Count")
      }
    }
  end
  defp wrap_data(%Error{} = error), do: {:error, error}

  defp handle_structure([], acc), do: Enum.reverse(acc)
  defp handle_structure([set | remaining_sets], acc),
    do: handle_structure(remaining_sets, [Transformations.structurize_map(set, %Set{}) | acc])
end
