defmodule AOC.Day6_2 do
  @moduledoc """
  --- Part Two ---

  Suppose the lanternfish live forever and have unlimited food and space. Would they take over the entire ocean?

  After 256 days in the example above, there would be a total of 26984457539 lanternfish!

  How many lanternfish would there be after 256 days?
  """

  def run(input) do
    population = initialize_population(input) |> IO.inspect(label: "population")

    Enum.reduce(1..256, population, &simulate_day/2) |> Map.values() |> Enum.sum() |> IO.inspect(label: "count")
  end

  defp initialize_population(input) do
    input
    |> File.stream!()
    |> Enum.to_list()
    |> List.first()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  defp simulate_day(day, prev_counts) do
    Enum.reduce(8..0, %{}, fn timer, new_counts ->
      prev_count = Map.get(prev_counts, timer, 0)

      if timer == 0 do
        six_count = Map.get(new_counts, 6, 0)

        new_counts
        |> Map.put(6, six_count + prev_count)
        |> Map.put(8, prev_count)
      else
        Map.put(new_counts, timer - 1, prev_count)
      end
    end)
  end
end
