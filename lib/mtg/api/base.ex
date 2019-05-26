defmodule Mtg.Api.Base do
  @moduledoc """
  Module defining a base module to call the API and parse the response
  """

  alias Mtg.{Card, Error}
  alias Mtg.Response.{Collection}

  @type filter_key :: atom() | binary()
  @type normal_filter :: {filter_key, any()}
  @type or_filter :: {filter_key, :or, list(binary())}
  @type and_filter :: {filter_key, :and, list(binary())}

  @callback call(list(normal_filter() | or_filter() | and_filter()) | number()) ::
              {:ok, Collection.t() | Card.t()} | {:error, Error.t()}

  defmacro __using__(_) do
    quote do
      @behaviour Mtg.Api.Base

      alias Mtg.{Error}

      @mtg_url "https://api.magicthegathering.io"

      @type headers :: [{binary(), binary()}]

      @spec get(binary()) :: {headers, list(map())} | Error.t()
      def get(url_path)do
        "#{@mtg_url}#{url_path}"
        |> HTTPoison.get([], [recv_timeout: 30000])
        |> handle_response()
      end

      defp handle_response({:ok, %HTTPoison.Response{status_code: 200, headers: headers, body: body}}),
        do: {headers, body |> Jason.decode!() |> Map.values() |> List.first()}
      defp handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}}),
        do: %Error{code: code, message: Jason.decode!(body)["error"]}
      defp handle_response({:error, %HTTPoison.Error{reason: reason}}),
        do: %Error{message: reason}
    end
  end
end
