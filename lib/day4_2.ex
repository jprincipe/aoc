defmodule AOC.Day4_2 do
  @moduledoc """
  --- Part Two ---

  On the other hand, it might be wise to try a different strategy: let the giant squid win.

  You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.

  In the above example, the second board is the last to win, which happens after 13 is eventually called and its middle column is completely marked. If you were to keep playing until this point, the second board would have a sum of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.

  Figure out which board will win last. Once it wins, what would its final score be?
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

      if Enum.count(boards) == 1 do
        {:halt, boards |> Enum.at(0) |> unmarked_sum() |> Kernel.*(number)}
      else
        {:cont, Enum.reject(boards, &winner?/1)}
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
