defmodule FileStream do
  @moduledoc false

  def read_book(start_line, end_line) do
    read_lines('lib/scrupulous/books/book.txt', start_line, end_line)
  end

  def read_lines(path, start_line, end_line) do
    File.stream!(path)
#    |> Stream.filter(fn(line) -> line != "\n" end)
    |> Stream.with_index()
    |> Stream.map(fn({line, indx}) -> %{line: indx, txt: line} end)
    |> Stream.take(end_line)
    |> Stream.filter(fn(%{line: indx, txt: line}) -> indx >= start_line end)
    |> Enum.to_list
  end

end
