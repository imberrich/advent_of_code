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

defmodule Diff do
  # requires sorted list
  def compare_all([]), do: nil
  def compare_all([h | t]) do
    case compare_to_list(h, t) do
      nil -> compare_all(t)
      ans -> ans
    end
  end

  # PRIVATE

  defp compare_to_list(_id, []), do: nil
  defp compare_to_list(id, [h | t]) do
    case compare_ids(id, h) do
      {:not_match} -> compare_to_list(h, t)
      {:ok, matched_diff} -> matched_diff 
    end
  end

  defp compare_ids(id1, id2) do
    case String.myers_difference(id1, id2) do
      # 1 char mismatch in middle
      [eq: start, del: del, ins: ins, eq: finish] ->
        if myers_matcher(del, ins), do: {:ok, start <> finish} 

      # 1 char mismatch at the end
      [eq: start, del: del, ins: ins] ->
        if myers_matcher(del, ins), do: {:ok, start}

      # 1 char mismatch at the beginning
      [del: del, ins: ins, eq: finish] ->
        if myers_matcher(del, ins), do: {:ok, finish}
      
      # no mismatch or non concurrent mismatch 
      _ -> 
        {:not_match}
    end
  end

  # checks to see if there is only 1 mismatched char
  defp myers_matcher(del, ins), do: String.length(del) == 1 && String.length(ins) == 1
end

input = File.read!("input.txt") |> String.split()

# pt1: what is the checksum for your list of box IDs
input
|> Checksum.calculate()
|> IO.puts()

# pt2: diff inputs to find 2 that have only 1 different char
input
|> Enum.sort()
|> Diff.compare_all()
|> IO.inspect()