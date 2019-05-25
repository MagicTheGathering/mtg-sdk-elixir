defmodule Mtg.Card.Legality do
  @moduledoc """
  Struct defining a card legality attributes and its types
  """

  defstruct [:format, :legality]

  @type t :: %__MODULE__{format: binary(), legality: binary()}
end

defimpl Collectable, for: Mtg.Card.Legality do
  def into(original) do
    collector_fun = fn
      set, {:cont, {key, value}} -> Map.put(set, key, value)
      set, :done -> set
      _set, :halt -> :ok
    end

    {original, collector_fun}
  end
end
