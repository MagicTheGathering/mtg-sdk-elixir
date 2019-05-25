defmodule Mtg.Tools.Transformations do
  @moduledoc """
  Module defining the functions to add all query params to an API url
  """

  alias Mtg.{Card}
  alias Mtg.Card.{ForeignName, Legality, Ruling}

  @spec add_number_header_value([{binary(), binary()}], binary()) :: nil | integer()
  def add_number_header_value(header, name),
    do: header |> List.keyfind(name, 0) |> cast_to_number()

  defp cast_to_number(nil), do: nil
  defp cast_to_number({_, item}) when is_number(item), do: item
  defp cast_to_number({_, item}) when is_binary(item), do: item |> String.to_integer()

  @spec structurize_map(map(), struct()) :: Card.t()
  def structurize_map(item, %Card{}), do: encapsulate_data(item, %Card{})

  defp encapsulate_data(item, set) do
    for {key, val} <- item,
      into: set,
      do: {key |> Inflex.underscore() |> String.to_atom(), structurize(key, val)}
  end

  defp structurize("foreignNames", foreign_names),
    do: foreign_names |> Enum.map(fn foreign_name -> encapsulate_data(foreign_name, %ForeignName{}) end)
  defp structurize("legalities", legalities),
    do: legalities |> Enum.map(fn legality -> encapsulate_data(legality, %Legality{}) end)
  defp structurize("rulings", rulings),
    do: rulings |> Enum.map(fn ruling -> encapsulate_data(ruling, %Ruling{}) end)
  defp structurize(_, item), do: item
end
