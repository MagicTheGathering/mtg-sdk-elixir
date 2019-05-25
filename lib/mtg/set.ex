defmodule Mtg.Set do
  @moduledoc """
  Struct defining a set and its attributes and types
  """

  defstruct [
    :block,
    :booster,
    :border,
    :code,
    :gatherer_code,
    :magic_cards_info_code,
    :mkm_id,
    :mkm_name,
    :name,
    :old_code,
    :online_only,
    :release_date,
    :type
  ]

  @type t :: %__MODULE__{
          block: binary(),
          booster: list(binary() | list(binary())),
          border: binary(),
          code: binary(),
          gatherer_code: binary(),
          magic_cards_info_code: binary(),
          mkm_id: integer(),
          mkm_name: binary(),
          name: binary(),
          old_code: binary(),
          online_only: boolean(),
          release_date: binary(),
          type: binary()
        }
end

defimpl Collectable, for: Mtg.Set do
  def into(original) do
    collector_fun = fn
      set, {:cont, {key, value}} -> Map.put(set, key, value)
      set, :done -> set
      _set, :halt -> :ok
    end

    {original, collector_fun}
  end
end
