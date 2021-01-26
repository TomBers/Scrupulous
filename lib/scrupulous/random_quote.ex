defmodule Scrupulous.RandomQuote do
  alias Scrupulous.StaticContent

  def random_quote() do
    book = StaticContent.get_random_book!()
    return_quote(book)
  end

  def quote_for_book(book_id) do
    book = StaticContent.get_book!(book_id)
    return_quote(book)
  end

  defp return_quote(book) do
    quote = get_quote(book)

    %{
      quote: quote.txt,
      title: book.title,
      author: book.author,
      url: "/reader/#{book.id}/page/#{quote.page}?sl=#{quote.start_line}&el=#{quote.end_line}"
    }
  end

  defp get_quote(book) do
    start_line = Enum.random(100..35990)

    lines =
      Store.get_between(book.file_name, start_line, start_line + 3)
      |> Enum.filter(fn {_lines, txt} -> String.trim(txt) != "" end)

    quote_txt = Enum.reduce(lines, "", fn {_line, txt}, acc -> acc <> txt end)

    if length(lines) == 0 or quote_is_legal_section(String.downcase(quote_txt)) do
      get_quote(book)
    else
      {sl, _txt} = List.first(lines)
      {el, _txt} = List.last(lines)

      %{
        txt: quote_txt,
        start_line: sl,
        end_line: el,
        page: div(sl, Scrupulous.Constants.lines_per_page())
      }
    end
  end

  defp quote_is_legal_section(txt) do
    bad_words = [
      "public domain",
      "copyright",
      "gutenberg",
      "work",
      "donations",
      "fees",
      "charges",
      "distribute",
      "redistributing",
      "written confirmation",
      "trademark",
      "http://",
      "transcriber",
      "damages",
      "email",
      "refund",
      "editions",
      "terms",
      "laws",
      "@",
      "disclaimers",
      "warranties",
      "section"
    ]

    bad_words
    |> Enum.map(fn wrd -> String.contains?(txt, wrd) end)
    |> Enum.any?()
  end
end
