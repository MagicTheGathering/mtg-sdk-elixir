defmodule Mtg.Error do
  @moduledoc """
  Struct defining a request error
  """

  defstruct [:code, :message]

  @type t :: %__MODULE__{code: integer(), message: binary()}
end
