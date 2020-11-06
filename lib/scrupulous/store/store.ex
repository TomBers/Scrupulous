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
    search_in_book(book, term, &split_term/2)
  end

  def search_in_book(book, term, compare_func) do
    book
    |> Enum.filter(fn ({_line, txt}) -> compare_func.(txt, term) end)
    |> Enum.reduce([], fn (line, acc) -> add_if_new_line(line, acc) end)
  end

  def add_if_new_line({line, txt}, acc) do
    if should_add_search_result?(line, acc) do
      acc ++ [{line, txt}]
    else
      acc
    end
  end

#  Given the way we split the search term into small parts, we will get results from multiple limes in the same paragraph
#  We want to filter lines that are too close together as they are part of the same part of the text

  def should_add_search_result?(_line, []), do: true

  def should_add_search_result?(line, acc) do
    lines = acc
            |> Enum.map(fn ({line_num, _txt}) -> line_num end)
    lines
    |> Enum.any?(fn (ln) -> Range.disjoint?(Range.new(ln - 2, ln + 2), Range.new(line, line)) end)
  end

  def split_term(txt, term) do
    ftxt =
      txt
      |> String.replace("\r", "")
      |> String.downcase()

    terms =
      term
      |> String.downcase()
      |> String.replace("\r", "")
      |> String.split(".")
      |> Enum.flat_map(fn (tm) -> String.split(tm, ",") end)
      |> Enum.filter(fn (tm) -> String.length(tm) > 5 end)

    terms
    |> Enum.map(fn (t) -> String.contains?(ftxt, t) end)
    |> Enum.any?()

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
