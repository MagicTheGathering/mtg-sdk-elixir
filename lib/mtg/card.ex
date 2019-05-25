defmodule Mtg.Card do
  @moduledoc """
  Struct defining a card and its attributes and types
  """

  defstruct [
    :artist,
    :border,
    :cmc,
    :colors,
    :color_identity,
    :flavor,
    :foreign_names,
    :hand,
    :id,
    :image_url,
    :layout,
    :legalities,
    :life,
    :loyalty,
    :mana_cost,
    :multiverseid,
    :name,
    :names,
    :number,
    :original_text,
    :original_type,
    :power,
    :printings,
    :rarity,
    :release_date,
    :reserved,
    :rulings,
    :set,
    :set_name,
    :source,
    :subtypes,
    :supertypes,
    :starter,
    :text,
    :timeshifted,
    :toughness,
    :type,
    :types,
    :variations,
    :watermark
  ]

  @type t :: %__MODULE__{
          artist: binary(),
          border: binary(),
          cmc: number(),
          colors: list(binary()),
          color_identity: list(binary()),
          flavor: binary(),
          foreign_names: list(Mtg.Card.ForeignName.t()),
          hand: any(),
          id: binary(),
          image_url: binary(),
          layout: binary(),
          legalities: list(Mtg.Card.Legality.t()),
          life: any(),
          loyalty: binary(),
          mana_cost: binary(),
          multiverseid: integer(),
          name: binary(),
          names: list(binary()),
          number: binary(),
          original_text: binary(),
          original_type: binary(),
          power: binary(),
          printings: list(binary()),
          rarity: binary(),
          release_date: binary(),
          reserved: boolean(),
          rulings: list(Mtg.Card.Ruling.t()),
          set: binary(),
          set_name: binary(),
          source: binary(),
          subtypes: list(binary()),
          supertypes: list(binary()),
          starter: boolean(),
          text: binary(),
          timeshifted: boolean(),
          toughness: binary(),
          type: binary(),
          types: list(binary()),
          variations: list(integer()),
          watermark: any()
        }
end

defimpl Collectable, for: Mtg.Card do
  def into(original) do
    collector_fun = fn
      set, {:cont, {key, value}} -> Map.put(set, key, value)
      set, :done -> set
      _set, :halt -> :ok
    end

    {original, collector_fun}
  end
end
