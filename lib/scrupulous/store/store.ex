defmodule Store do

  def get_between(key, s, e) do
    StoreHelpers.fetch_book_if_not_present(key, &store_book/2)
    |> Enum.reduce_while([], fn (line, acc) -> add_line?(line, acc, s, e) end)
  end

  def store_book(k, v) do
    :persistent_term.put(k, v)
  end

  def search(key, term) do
    StoreHelpers.fetch_book_if_not_present(key, &store_book/2)
    |> Enum.filter(fn ({_line, txt}) -> String.contains?(String.downcase(txt), String.downcase(term)) end)
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
