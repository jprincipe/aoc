defmodule AOC.Day4_1 do
  @moduledoc """
  --- Day 4: Giant Squid ---

  You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.

  Maybe it wants to play bingo?

  Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)

  The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:

  ```
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
  8  2 23  4 24
  21  9 14 16  7
  6 10  3 18  5
  1 12 20 15 19

  3 15  0  2 22
  9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
  2  0 12  3  7
  ```

  After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):

  ```
  22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
  21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
  After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:

  22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
  21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
  Finally, 24 is drawn:

  22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
  21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
  ```
  At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).

  The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.

  To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?
  """

  def run(input) do
    [numbers | boards] = input |> File.stream!() |> Enum.to_list()

    numbers = parse_numbers(numbers)
    boards = setup_boards(boards)

    play(boards, numbers) |> IO.inspect(label: "winner")
  end

  defp parse_numbers(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp setup_boards(input) do
    input
    |> Enum.chunk_every(6, 6, :discard)
    |> Enum.map(&setup_board/1)
  end

  defp setup_board([_ | rows]) do
    Enum.reduce(0..4, %{}, fn x, board ->
      Enum.reduce(0..4, board, fn y, board ->
        row = rows |> Enum.at(x) |> String.trim() |> String.split(~r{\s+})
        number = row |> Enum.at(y) |> String.trim() |> String.to_integer()
        Map.put(board, {x, y}, {number, false})
      end)
    end)
  end

  defp play(boards, numbers) do
    Enum.reduce_while(numbers, boards, fn number, boards ->
      boards = Enum.map(boards, &mark_board(&1, number))

      if board = Enum.find(boards, &winner?/1) do
        {:halt, unmarked_sum(board) * number}
      else
        {:cont, boards}
      end
    end)
  end

  defp mark_board(board, value) do
    case Enum.find(board, fn {_position, {number, _marked}} -> number == value end) do
      {position, _square} -> put_in(board, [position], {value, true})
      _ -> board
    end
  end

  defp winner?(board) do
    winning_row = Enum.find(0..4, fn row -> row_winner?(board, row) end)
    winning_col = Enum.find(0..4, fn col -> col_winner?(board, col) end)

    winning_row || winning_col
  end

  defp row_winner?(board, row), do: board |> row_squares(row) |> Enum.count(fn {_position, {_number, marked}} -> marked end) |> Kernel.==(5)
  defp col_winner?(board, col), do: board |> col_squares(col) |> Enum.count(fn {_position, {_number, marked}} -> marked end) |> Kernel.==(5)

  defp col_squares(board, col), do: Enum.filter(board, fn {position, _} -> col == elem(position, 1) end)
  defp row_squares(board, row), do: Enum.filter(board, fn {position, _} -> row == elem(position, 0) end)

  defp unmarked_sum(board) do
    board
    |> Enum.filter(fn {_position, {_number, marked}} -> !marked end)
    |> Enum.map(fn {_position, {number, _marked}} -> number end)
    |> Enum.sum()
  end
end
