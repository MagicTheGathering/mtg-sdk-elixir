defmodule Mtg.Request.Query do
  def build_path(path, params),
    do: "#{path}#{params |> process_list([])}"

  defp process_list([], []), do: ""
  defp process_list([], acc), do: "?#{acc |> Enum.join("&")}"
  defp process_list([{param, :or, values} | tail], acc) when is_list(values),
    do: process_list(tail, ["#{normalize(param)}=#{Enum.join(values, "|")}" | acc])
  defp process_list([{param, :and, values} | tail], acc) when is_list(values),
    do: process_list(tail, ["#{normalize(param)}=#{Enum.join(values, ",")}" | acc])
  defp process_list([{param, value} | tail], acc) when is_binary(value) or is_number(value),
    do: process_list(tail, ["#{normalize(param)}=#{value}" | acc])

  defp normalize(param), do: "#{param}" |> Inflex.camelize(:lower)
end
