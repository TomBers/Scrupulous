defmodule SampleData do
  alias Scrupulous.StaticContent

  def books do
    [
      %{title: "A Hero of Our Time", author: "Mikhail Lermontov", country: "Russia", publication_year: 1840, file_name: "913-0" },
      %{title: "Anna Karenina", author: "Leo Tolstoy", country: "Russia", publication_year: 1877, file_name: "1399-0"},
      %{title: "War and Peace", author: "Leo Tolstoy", country: "Russia", publication_year: 1867, file_name: "2600-0"},
      %{title: "The Idiot", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1874, file_name: "2638-0"},
      %{title: "Rudin", author: "Ivan Turgenev", country: "Russia", publication_year: 1832, file_name: "6900-0"},
      %{title: "The Devils", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1871, file_name: "8117-0"},
      %{title: "Eugene Onegin", author: "Alexander Pushkin", country: "Russia", publication_year: 1832, file_name: "23997-0"},
      %{title: "The Brothers Karamazov", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1880, file_name: "28054-0"},
      %{title: "Notes from the Underground", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1864, file_name: "pg600"},
      %{title: "The Daughter of the Commandant", author: "Alexander Pushkin", country: "Russia", publication_year: 1831, file_name: "pg13511"},
      %{title: "Fathers and Children", author: "Ivan Turgenev", country: "Russia", publication_year: 1862, file_name: "pg30723"},
      %{title: "The Turn of the Screw", author: "Henry James", country: "USA", publication_year: 1898, file_name: "209-0"},
      %{title: "Pragmatism: A New Name for Some Old Ways of Thinking", author: "William James", country: "USA", publication_year: 1907, file_name: "pg5116"},
      %{title: "Fifty Famous Stories Retold", author: "James Baldwin", country: "USA", publication_year: 1896, file_name: "pg18442"},
      %{title: "The Adventures of Tom Sawyer", author: "Mark Twain", country: "USA", publication_year: 1876, file_name: "74-0"},
      %{title: "Adventures of Huckleberry Finn", author: "Mark Twain", country: "USA", publication_year: 1884, file_name: "76-0"},
      %{title: "The Big Trip Up Yonder", author: "Kurt Vonnegut", country: "USA", publication_year: 1954, file_name: "pg30240"},
    ]
  end

  def make_books do
    books()
    |> Enum.map(fn(book) -> Map.put(book, :slug, make_slug(book.title, book.author)) end)
    |> Enum.map(fn(book) -> StaticContent.create_book(book) end)
  end

  def make_slug(title, author) do
    slug_title = title |> String.downcase |> String.replace(" ", "-")
    slug_author = author |> String.downcase |> String.replace(" ", "-")
    "#{slug_title}_#{slug_author}"
  end

end
