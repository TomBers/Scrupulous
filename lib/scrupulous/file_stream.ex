defmodule FileStream do
  @moduledoc false

  def read_book(page) do
    read_lines('lib/scrupulous/books/book.txt', page * 50, 50)
  end

  def read_lines(path, start_line \\ 0, lines \\ 10) do
    end_line = start_line + lines
    File.stream!(path)
#    |> Stream.filter(fn(line) -> line != "\n" end)
    |> Stream.with_index()
    |> Stream.map(fn({line, indx}) -> %{line: indx, txt: line} end)
    |> Stream.take(end_line)
    |> Stream.filter(fn(%{line: indx, txt: line}) -> indx >= start_line end)
    |> Enum.to_list
  end

end
