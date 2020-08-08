defmodule ScrupulousWeb.BookView do
  use ScrupulousWeb, :view

  def only_show_books(books) do
    books
    |> Enum.filter(fn(book) -> is_nil(book.type) end)
  end

end
