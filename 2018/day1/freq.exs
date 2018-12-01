# run with `elixir freq.exs`

defmodule FreqFinder do

  # {input list, current_freq, freq_list}
  def find_repeated({[], current_freq, freq_list}) do
    IO.puts("Wrapping...")
    find_repeated({Inputs.list(), current_freq, freq_list})
  end

  def find_repeated({[h | t], current_freq, freq_list}) do
    new_freq = h + current_freq
      if Enum.member?(freq_list, new_freq) do
        new_freq
      else
        find_repeated({t, new_freq, [new_freq] ++ freq_list})
      end
  end
end

defmodule Inputs do
  @inputs File.read!("input.txt")
          |> String.split()
          |> Enum.map(fn x -> String.to_integer(x) end)
  
  def list(:test), do: [+7, +7, -2, -7, -4] # 14
  def list(), do: @inputs
end


# solve pt1: 
total = Enum.reduce(Inputs.list(), fn x, acc -> x + acc end)
IO.puts "pt1: #{total}"

# solve pt2: 
IO.puts "pt2: #{FreqFinder.find_repeated({Inputs.list(), 0, [0]})} 



