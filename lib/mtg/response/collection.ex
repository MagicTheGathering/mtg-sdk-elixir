defmodule Mtg.Response.Collection do
  @moduledoc """
  Response that encapsulates object collections
  """

  alias Mtg.{Card, Set}

  defstruct [:type, :data, :page_size, :count, :total_count]

  @type t :: %__MODULE__{
          type: binary(),
          data: list(Card.t() | Set.t()),
          page_size: integer(),
          count: integer(),
          total_count: integer()
        }
end