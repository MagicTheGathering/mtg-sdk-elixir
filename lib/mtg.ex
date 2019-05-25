defmodule Mtg do
  @moduledoc """
  Module defining all API calls
  """

  alias Mtg.{Card, Error}
  alias Mtg.Response.{Collection}

  @spec list(module(), [{atom() | String.t(), any()}]) :: {:ok, Collection.t()} | {:error, Error.t()}
  def list(Card, query_params \\ []) when is_list(query_params),
    do: query_params |> Mtg.Api.ListCards.call()
end
