defmodule ScrupulousWeb.BookController do
  use ScrupulousWeb, :controller

  alias Scrupulous.StaticContent

  def index(conn, _params) do
    books = StaticContent.list_books()
    render(conn, "index.html", books: books)
  end

  def author_by_letter(conn, %{"letter" => letter}) do
    books = StaticContent.authors_starting_with("#{letter}%") |> filter_read_me()
    render(conn, "index.html", books: books)
  end

  def search(conn, %{"term" => term}) do
    books = StaticContent.search("%#{term}%") |> filter_read_me()
    render(conn, "index.html", books: books)
  end

  def filter_read_me(books) do
    Enum.filter(books, fn(book) -> !String.ends_with?(book.file_name, "readme.txt") end)
  end

  def show(conn, %{"id" => id}) do
    book = StaticContent.get_book!(id)
    render(conn, "show.html", book: book)
  end

  def books_api(conn, _params) do
    books =
      StaticContent.list_books()
      |> Enum.map(fn(book) -> %{id: book.id, author: book.author, title: book.title} end)

    json(conn, books)
  end

end
