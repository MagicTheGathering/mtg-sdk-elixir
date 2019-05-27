defmodule Mtg do
  @moduledoc """
  Module defining all API calls
  """

  alias __MODULE__.{Error}
  alias __MODULE__.Api.{GenerateSetBooster, ListCards, ListSets, ListStrings, ShowCard, ShowSet}
  alias __MODULE__.Response.{Collection}

  @type filters :: list({atom() | binary(), any()})

  @spec list(module()) :: {:ok, list(binary())} | {:error, Error.t()}
  def list(Type), do: ListStrings.call(Type)
  def list(Subtype), do: ListStrings.call(Subtype)
  def list(Supertype), do: ListStrings.call(Supertype)
  def list(Format), do: ListStrings.call(Format)

  @spec list(module(), filters()) :: {:ok, Collection.t()} | {:error, Error.t()}
  def list(type, params \\ [])
  def list(Card, params) when is_list(params), do: params |> ListCards.call()
  def list(Set, params) when is_list(params), do: params |> ListSets.call()

  @spec show(module(), binary()) :: {:ok, Mtg.Card.t() | Mtg.Set.t()} | {:error, Error.t()}
  def show(Card, id) when is_number(id), do: id |> ShowCard.call()
  def show(Set, code) when is_binary(code), do: code |> ShowSet.call()

  @spec generate_set_booster(binary()) :: {:ok, Collection.t()} | {:error, Error.t()}
  def generate_set_booster(code), do: code |> GenerateSetBooster.call()
end
