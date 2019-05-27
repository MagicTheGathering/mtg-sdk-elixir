defmodule Mtg.Api.ListStrings do
  @moduledoc """
  Module defining the listing types API call
  """

  use Mtg.Api.Base

  alias Mtg.{Error}

  @spec call(module()) :: {:ok, list(binary())} | {:error, Error.t()}
  def call(Type), do: "/v1/types" |> get() |> wrap_data()
  def call(Subtype), do: "/v1/subtypes" |> get() |> wrap_data()
  def call(Supertype), do: "/v1/supertypes" |> get() |> wrap_data()
  def call(Format), do: "/v1/formats" |> get() |> wrap_data()

  defp wrap_data({_headers, data}), do: {:ok, data}
  defp wrap_data(%Error{} = error), do: {:error, error}
end
