defmodule Mtg.Card do
  @moduledoc """
  Struct defining a card attributes and its types
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
          artist: String.t(),
          border: String.t(),
          cmc: number,
          colors: [String.t()],
          color_identity: [String.t()],
          flavor: String.t(),
          foreign_names: [Mtg.Card.ForeignName.t()],
          hand: any,
          id: String.t(),
          image_url: String.t(),
          layout: String.t(),
          legalities: [Mtg.Card.Legality.t()],
          life: any,
          loyalty: String.t(),
          mana_cost: String.t(),
          multiverseid: integer,
          name: String.t(),
          names: [String.t()],
          number: String.t(),
          original_text: String.t(),
          original_type: String.t(),
          power: String.t(),
          printings: [String.t()],
          rarity: String.t(),
          release_date: String.t(),
          reserved: boolean,
          rulings: [Mtg.Card.Ruling.t()],
          set: String.t(),
          set_name: String.t(),
          source: String.t(),
          subtypes: [String.t()],
          supertypes: [String.t()],
          starter: boolean,
          text: String.t(),
          timeshifted: boolean,
          toughness: String.t(),
          type: String.t(),
          types: [String.t()],
          variations: [integer],
          watermark: any
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
