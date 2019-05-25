defmodule Mtg do
  @moduledoc """
  Module defining all API calls
  """

  alias Mtg.{Card, Set, Error}
  alias Mtg.Response.{Collection}

  @type filters :: list({atom() | binary(), any()})

  @spec list(module(), filters()) :: {:ok, Collection.t()} | {:error, Error.t()}
  def list(type, query_params \\ [])
  def list(Card, query_params) when is_list(query_params),
    do: query_params |> Mtg.Api.ListCards.call()
  def list(Set, query_params) when is_list(query_params),
    do: query_params |> Mtg.Api.ListSets.call()
end
