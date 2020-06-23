defmodule ScrupulousWeb.PageController do
  use ScrupulousWeb, :controller
  alias Scrupulous.UserContent

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def book(conn, %{"page" => pageStr}) do
    {page, _rem} = Integer.parse(pageStr)
    start_line = page * 50
    end_line = start_line + 50
    book = "7"
    notes = UserContent.get_notes_between_lines(book, start_line, end_line)
    lines = FileStream.read_book(start_line, end_line)
    render(conn, "book.html", book: page, notes: notes, lines: lines, next_page: page + 1, previous_page: page - 1)
  end
end
