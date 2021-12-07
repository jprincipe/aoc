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
end
