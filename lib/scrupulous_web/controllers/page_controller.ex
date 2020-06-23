defmodule ScrupulousWeb.PageController do
  use ScrupulousWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def book(conn, %{"page" => pageStr}) do
    {page, _rem} = Integer.parse(pageStr)
    lines = FileStream.read_book(page)
    render(conn, "book.html", book: page, lines: lines, next_page: page + 1, previous_page: page - 1)
  end
end
