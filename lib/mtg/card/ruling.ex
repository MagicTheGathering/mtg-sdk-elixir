defmodule Mtg.Card.Ruling do
  @moduledoc """
  Struct defining a card ruling attributes and its types
  """

  defstruct [:date, :text]

  @type t :: %__MODULE__{date: String.t(), text: String.t()}
end

defimpl Collectable, for: Mtg.Card.Ruling do
  def into(original) do
    collector_fun = fn
      set, {:cont, {key, value}} -> Map.put(set, key, value)
      set, :done -> set
      _set, :halt -> :ok
    end

    {original, collector_fun}
  end
end
