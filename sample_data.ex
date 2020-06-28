defmodule SampleData do
  alias Scrupulous.StaticContent

  def books do
    [
      %{title: "A Hero of Our Time", author: "Mikhail Lermontov", country: "Russia", publication_year: 1840, file_name: '913-0.txt' },
      %{title: "Anna Karenina", author: "Leo Tolstoy", country: "Russia", publication_year: 1877, file_name: '1399-0.txt'},
      %{title: "War and Peace", author: "Leo Tolstoy", country: "Russia", publication_year: 1867, file_name: '2600-0.txt'},
      %{title: "The Idiot", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1874, file_name: '2638-0.txt'},
      %{title: "Rudin", author: "Ivan Turgenev", country: "Russia", publication_year: 1832, file_name: '6900-0.txt'},
      %{title: "The Devils", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1871, file_name: '8117-0.txt'},
      %{title: "Eugene Onegin", author: "Alexander Pushkin", country: "Russia", publication_year: 1832, file_name: '23997-0.txt'},
      %{title: "The Brothers Karamazov", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1880, file_name: '28054-0.txt'},
      %{title: "Notes from the Underground", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1864, file_name: 'pg600.txt'},
      %{title: "The Daughter of the Commandant", author: "Alexander Pushkin", country: "Russia", publication_year: 1831, file_name: 'pg13511.txt'},
      %{title: "Fathers and Children", author: "Ivan Turgenev", country: "Russia", publication_year: 1862, file_name: 'pg30723.txt'},
    ]
  end

  def make_books do
    books()
    |> Enum.map(fn(book) -> StaticContent.create_book(book) end)
  end

end
