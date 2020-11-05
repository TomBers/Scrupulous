defmodule Store do

  def get_between(key, s, e) do
    StoreHelpers.fetch_book_if_not_present(key, &store_book/2)
    |> Enum.reduce_while([], fn (line, acc) -> add_line?(line, acc, s, e) end)
  end

  def store_book(k, v) do
    :persistent_term.put(k, v)
  end

  def search(key, term) do
    book = StoreHelpers.fetch_book_if_not_present(key, &store_book/2)
    book
    |> Enum.filter(fn ({line, txt}) -> compare_func(txt, term, line, book) end)
  end

  defp compare_func(txt, term, line, book) do
    String.contains?(compare_string(book, line), term)
  end

  defp compare_string(book, line) when line > 0 and line < length(line) do
    {_num, previous_line_txt} = Enum.at(book, line - 1)
    {_num, txt} = Enum.at(book, line)
    {_num, next_line_txt} = Enum.at(book, line + 1)
    "#{previous_line_txt} #{txt} #{next_line_txt}"
  end

  defp compare_string(book, line) do
    {_num, txt} = Enum.at(book, line)
    txt
  end

  #  Helpers

  def add_line?({line, txt}, acc, s, e) when line >= s and line <= e do
    {:cont, acc ++ [{line, txt}]}
  end

  def add_line?({line, _txt}, acc, _s, e) when line > e do
    {:halt, acc}
  end

  def add_line?(_line, acc, _s, _e) do
    {:cont, acc}
  end



end
