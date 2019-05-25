defmodule Mtg.Tools.Transformations do
  @moduledoc """
  Module defining the functions to add all query params to an API url
  """

  alias Mtg.{Card, Set}
  alias Mtg.Card.{ForeignName, Legality, Ruling}

  @spec add_number_header_value(list({binary(), binary()}), binary()) :: nil | integer()
  def add_number_header_value(header, name),
    do: header |> List.keyfind(name, 0) |> cast_to_number()

  defp cast_to_number(nil), do: nil
  defp cast_to_number({_, item}) when is_number(item), do: item
  defp cast_to_number({_, item}) when is_binary(item), do: item |> String.to_integer()

  @spec structurize_map(map(), struct()) :: Card.t() | Set.t()
  def structurize_map(item, %Card{}), do: encapsulate_data(item, %Card{})
  def structurize_map(item, %Set{}), do: encapsulate_data(item, %Set{})

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
  defp structurize(key, nil) when key in ["date", "releaseDate"], do: nil
  defp structurize(key, date) when key in ["date", "releaseDate"],
    do: date |> Date.from_iso8601!()
  defp structurize(_, item), do: item
end
