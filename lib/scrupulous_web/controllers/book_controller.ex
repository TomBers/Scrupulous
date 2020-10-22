defmodule ScrupulousWeb.BookController do
  use ScrupulousWeb, :controller

  alias Scrupulous.StaticContent
  alias Scrupulous.StaticContent.Book

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

  def new(conn, _params) do
    changeset = StaticContent.change_book(%Book{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"book" => book_params}) do
    case StaticContent.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    book = StaticContent.get_book!(id)
    render(conn, "show.html", book: book)
  end

  def edit(conn, %{"id" => id}) do
    book = StaticContent.get_book!(id)
    changeset = StaticContent.change_book(book)
    render(conn, "edit.html", book: book, changeset: changeset)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = StaticContent.get_book!(id)

    case StaticContent.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", book: book, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = StaticContent.get_book!(id)
    {:ok, _book} = StaticContent.delete_book(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: Routes.book_path(conn, :index))
  end
end
