defmodule Scrupulous.RandomQuote do
  alias Scrupulous.StaticContent

  def random_quote() do
    book = StaticContent.get_random_book!()
    quote = get_quote(book)

    %{
      quote: quote.txt,
      title: book.title,
      author: reverse_author_name(book.author),
      url: "reader/#{book.id}/page/#{quote.page}?sl=#{quote.start_line}&el=#{quote.end_line}"
    }
  end

  defp reverse_author_name(name) when is_nil(name) do
    "Anon"
  end

  defp reverse_author_name(name) do
    parts = String.split(name, " ")
    "#{List.last(parts)} #{List.first(parts)}"
  end

  defp get_quote(book) do
    start_line = Enum.random(100..35990)

    lines =
      Store.get_between(book.file_name, start_line, start_line + 3)
      |> Enum.filter(fn {_lines, txt} -> String.trim(txt) != "" end)

    if length(lines) == 0 do
      get_quote(book)
    else
      {sl, _txt} = List.first(lines)
      {el, _txt} = List.last(lines)

      %{
        txt: Enum.reduce(lines, "", fn {_line, txt}, acc -> acc <> txt end),
        start_line: sl,
        end_line: el,
        page: div(sl, Scrupulous.Constants.lines_per_page())
      }
    end
  end
end
