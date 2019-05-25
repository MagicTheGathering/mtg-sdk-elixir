defmodule Mtg.Response.Collection do
  @moduledoc """
  Response that encapsulates a collections of  objects
  """

  alias Mtg.{Card}

  defstruct [:type, :data, :page_size, :count, :total_count]

  @type t :: %__MODULE__{
          type: String.t(),
          data: [Card.t()],
          page_size: integer,
          count: integer,
          total_count: integer
        }
end