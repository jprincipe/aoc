defmodule AOC do
  @moduledoc """
  Documentation for `AOC`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AOC.hello()
      :world

  """
  def day1_1, do: AOC.Day1_1.run("lib/inputs/day1.txt")
  def day1_2, do: AOC.Day1_2.run("lib/inputs/day1.txt")

  def day2_1, do: AOC.Day2_1.run("lib/inputs/day2.txt")
  def day2_2, do: AOC.Day2_2.run("lib/inputs/day2.txt")

  def day3_1, do: AOC.Day3_1.run("lib/inputs/day3.txt")
  def day3_2, do: AOC.Day3_2.run("lib/inputs/day3.txt")

  def day4_1, do: AOC.Day4_1.run("lib/inputs/day4.txt")
  def day4_2, do: AOC.Day4_2.run("lib/inputs/day4.txt")

  def day5_1, do: AOC.Day5_1.run("lib/inputs/day5.txt")
  def day5_2, do: AOC.Day5_2.run("lib/inputs/day5.txt")

  def day6_1, do: AOC.Day6_1.run("lib/inputs/day6.txt")
  def day6_2, do: AOC.Day6_2.run("lib/inputs/day6.txt")
end
