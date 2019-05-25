defmodule Mtg do
  @moduledoc """
  Module defining all API calls
  """

  alias __MODULE__.{Error}
  alias __MODULE__.Api.{ListCards, ListSets, ShowCard}
  alias __MODULE__.Response.{Collection}

  @type filters :: list({atom() | binary(), any()})

  @spec list(module(), filters()) :: {:ok, Collection.t()} | {:error, Error.t()}
  def list(type, params \\ [])
  def list(Card, params) when is_list(params), do: params |> ListCards.call()
  def list(Set, params) when is_list(params), do: params |> ListSets.call()

  @spec show(module(), binary()) :: {:ok, Mtg.Card.t()} | {:error, Error.t()}
  def show(Card, id) when is_number(id), do: id |> ShowCard.call()
end
