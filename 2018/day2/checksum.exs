defmodule Checksum do
  
  def calculate(id_list) do 
    id_list
    |> to_counted_list()
    |> sum_count_list()
    |> multiply_count()
  end

  # PRIVATE 
  
  defp to_counted_list(id_list) when is_list(id_list) do
    for id <- id_list do
      id
      |> String.graphemes()
      |> count_occurences()
    end
  end

  defp count_occurences(list) when is_list(list) do
    raw_count = 
      Enum.reduce(list, %{}, fn x, acc ->
        case Map.get(acc, x) do
          nil -> Map.put(acc, x, 1)
          n -> Map.put(acc, x, n + 1)
        end
      end)

    Enum.reduce(raw_count, {0, 0}, fn 
      {_k, 2}, {_double, triple} -> {1, triple}
      {_k, 3}, {double, _triple} -> {double, 1}
      {_k, _v}, acc              -> acc
    end)
  end

  defp sum_count_list(list) do
    Enum.reduce(list, {0, 0}, fn {next_d, next_t}, {total_d, total_t} -> 
      {total_d + next_d, total_t + next_t}
    end)
  end

  defp multiply_count({x, y}), do: x * y

end

# pt1: what is the checksum for your list of box IDs
"input.txt"
|> File.read!() 
|> String.split()
|> Checksum.calculate()
|> IO.puts()