defmodule SampleData do
  alias Scrupulous.StaticContent
  alias Scrupulous.UserContent

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

  def make_edges do
    edges()
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.map(fn(edge) -> UserContent.create_edge(edge) end)
  end

  def edges do
    [
      %{source_id: 1, target_id: 5, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 7, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 10, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 2, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 3, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 4, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 6, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 8, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 9, label: "A Hero of Our Time"},
      %{source_id: 1, target_id: 11, label: "A Hero of Our Time"},
      %{source_id: 2, target_id: 3, label: "Anna Karenina"},
      %{source_id: 2, target_id: 4, label: "Anna Karenina"},
      %{source_id: 2, target_id: 6, label: "Anna Karenina"},
      %{source_id: 2, target_id: 8, label: "Anna Karenina"},
      %{source_id: 2, target_id: 15, label: "Anna Karenina"},
      %{source_id: 2, target_id: 16, label: "Anna Karenina"},
      %{source_id: 2, target_id: 5, label: "Anna Karenina"},
      %{source_id: 2, target_id: 7, label: "Anna Karenina"},
      %{source_id: 2, target_id: 9, label: "Anna Karenina"},
      %{source_id: 2, target_id: 10, label: "Anna Karenina"},
      %{source_id: 2, target_id: 11, label: "Anna Karenina"},
      %{source_id: 3, target_id: 4, label: "War and Peace"},
      %{source_id: 3, target_id: 6, label: "War and Peace"},
      %{source_id: 3, target_id: 9, label: "War and Peace"},
      %{source_id: 3, target_id: 11, label: "War and Peace"},
      %{source_id: 3, target_id: 5, label: "War and Peace"},
      %{source_id: 3, target_id: 7, label: "War and Peace"},
      %{source_id: 3, target_id: 8, label: "War and Peace"},
      %{source_id: 3, target_id: 10, label: "War and Peace"},
      %{source_id: 3, target_id: 11, label: "War and Peace"},
      %{source_id: 4, target_id: 6, label: "The Idiot"},
      %{source_id: 4, target_id: 8, label: "The Idiot"},
      %{source_id: 4, target_id: 9, label: "The Idiot"},
      %{source_id: 4, target_id: 15, label: "The Idiot"},
      %{source_id: 4, target_id: 16, label: "The Idiot"},
      %{source_id: 4, target_id: 5, label: "The Idiot"},
      %{source_id: 4, target_id: 7, label: "The Idiot"},
      %{source_id: 4, target_id: 10, label: "The Idiot"},
      %{source_id: 4, target_id: 11, label: "The Idiot"},
      %{source_id: 5, target_id: 7, label: "Rudin"},
      %{source_id: 5, target_id: 10, label: "Rudin"},
      %{source_id: 5, target_id: 6, label: "Rudin"},
      %{source_id: 5, target_id: 7, label: "Rudin"},
      %{source_id: 5, target_id: 8, label: "Rudin"},
      %{source_id: 5, target_id: 9, label: "Rudin"},
      %{source_id: 5, target_id: 11, label: "Rudin"},
      %{source_id: 6, target_id: 8, label: "The Devils"},
      %{source_id: 6, target_id: 9, label: "The Devils"},
      %{source_id: 6, target_id: 11, label: "The Devils"},
      %{source_id: 6, target_id: 15, label: "The Devils"},
      %{source_id: 6, target_id: 7, label: "The Devils"},
      %{source_id: 6, target_id: 10, label: "The Devils"},
      %{source_id: 6, target_id: 8, label: "The Devils"},
      %{source_id: 7, target_id: 10, label: "Eugene Onegin"},
      %{source_id: 7, target_id: 8, label: "Eugene Onegin"},
      %{source_id: 7, target_id: 9, label: "Eugene Onegin"},
      %{source_id: 7, target_id: 11, label: "Eugene Onegin"},
      %{source_id: 8, target_id: 15, label: "The Brothers Karamazov"},
      %{source_id: 8, target_id: 16, label: "The Brothers Karamazov"},
      %{source_id: 8, target_id: 9, label: "The Brothers Karamazov"},
      %{source_id: 8, target_id: 10, label: "The Brothers Karamazov"},
      %{source_id: 8, target_id: 11, label: "The Brothers Karamazov"},
      %{source_id: 8, target_id: 9, label: "The Brothers Karamazov"},
      %{source_id: 9, target_id: 11, label: "Notes from the Underground"},
      %{source_id: 9, target_id: 10, label: "Notes from the Underground"},
      %{source_id: 9, target_id: 11, label: "Notes from the Underground"},
      %{source_id: 10, target_id: 11, label: "The Daughter of the Commandant"},
      %{source_id: 10, target_id: 8, label: "The Daughter of the Commandant"},
      %{source_id: 11, target_id: 10, label: "Fathers and Children"},
      %{source_id: 11, target_id: 8, label: "Fathers and Children"},
      %{source_id: 11, target_id: 10, label: "The Daughter of the Commandant"},
      %{source_id: 12, target_id: 13, label: "The Turn of the Screw"},
      %{source_id: 12, target_id: 14, label: "The Turn of the Screw"},
      %{source_id: 12, target_id: 15, label: "The Turn of the Screw"},
      %{source_id: 12, target_id: 16, label: "The Turn of the Screw"},
      %{source_id: 12, target_id: 17, label: "The Turn of the Screw"},
      %{source_id: 13, target_id: 14, label: "Pragmatism: A New Name for Some Old Ways of Thinking"},
      %{source_id: 13, target_id: 15, label: "Pragmatism: A New Name for Some Old Ways of Thinking"},
      %{source_id: 13, target_id: 16, label: "Pragmatism: A New Name for Some Old Ways of Thinking"},
      %{source_id: 13, target_id: 17, label: "Pragmatism: A New Name for Some Old Ways of Thinking"},
      %{source_id: 14, target_id: 15, label: "Fifty Famous Stories Retold"},
      %{source_id: 14, target_id: 16, label: "Fifty Famous Stories Retold"},
      %{source_id: 14, target_id: 17, label: "Fifty Famous Stories Retold"},
      %{source_id: 15, target_id: 16, label: "The Adventures of Tom Sawyer"},
      %{source_id: 15, target_id: 17, label: "The Adventures of Tom Sawyer"},
      %{source_id: 15, target_id: 16, label: "The Adventures of Tom Sawyer"},
      %{source_id: 16, target_id: 17, label: "Adventures of Huckleberry Finn"},
      %{source_id: 16, target_id: 15, label: "Adventures of Huckleberry Finn"},
      %{source_id: 17, target_id: 15, label: "The big trip up Yonder"},
      %{source_id: 17, target_id: 16, label: "The big trip up Yonder"},
    ]
  end


  def make_resources do
    resources()
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.map(fn(resource) -> StaticContent.create_resource(resource) end)
  end

  def resources do
    [
      %{user_id: 1, category: "BUY", book_id: 1, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/9780140447958" },
      %{user_id: 1, category: "BUY", book_id: 2, label: "Daunt Books", link: "https://dauntbooks.co.uk/shop/books/anna-karenina-2/" },
      %{user_id: 1, category: "BUY", book_id: 3, label: "Daunt Books", link: "https://dauntbooks.co.uk/shop/books/war-and-peace/" },
      %{user_id: 1, category: "BUY", book_id: 4, label: "Daunt Books", link: "https://dauntbooks.co.uk/shop/books/the-idiot-2/" },
      %{user_id: 1, category: "BUY", book_id: 5, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/Rudin-by-Turgenev-Ivan/9783732637331" },
      %{user_id: 1, category: "BUY", book_id: 6, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/The-Possessed-the-Devils-by-Fyodor-Dostoyevsky-author/9781419178283" },
      %{user_id: 1, category: "BUY", book_id: 7, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/Eugene-Onegin-by-Aleksandr-Sergeevich-Pushkin-Stanley-Mitchell/9780140448108" },
      %{user_id: 1, category: "BUY", book_id: 8, label: "Daunt Books", link: "https://dauntbooks.co.uk/shop/books/the-brothers-karamazov/" },
      %{user_id: 1, category: "BUY", book_id: 9, label: "Daunt Books", link: "https://dauntbooks.co.uk/shop/books/notes-from-underground/" },
      %{user_id: 1, category: "BUY", book_id: 10, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/The-Daughter-of-the-Commandant-by-Aleksandr-Sergeyevich-Pushkin-author/9781679909153" },
      %{user_id: 1, category: "BUY", book_id: 11, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/Fathers-and-Children-by-Ivan-Sergeevich-Turgenev-Michael-R-Katz/9780393927979" },
      %{user_id: 1, category: "BUY", book_id: 12, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/The-Turn-of-the-Screw-by-Henry-James-David-Bromwich/9780141441351" },
      %{user_id: 1, category: "BUY", book_id: 13, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/Pragmatism-A-New-Name-for-Some-Old-Ways-of-Thinking-by-James-William/9781374916548" },
      %{user_id: 1, category: "BUY", book_id: 14, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/Fifty-Famous-Stories-Retold-by-James-Baldwin/9781603862066" },
      %{user_id: 1, category: "BUY", book_id: 15, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/The-Adventures-of-Tom-Sawyer-by-Mark-Twain-Peter-Stoneley/9780199536566" },
      %{user_id: 1, category: "BUY", book_id: 16, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/Adventures-of-Huckleberry-Finn-by-Mark-Twain-Emory-Elliott/9780199536559" },
      %{user_id: 1, category: "BUY", book_id: 17, label: "Blackwells", link: "https://blackwells.co.uk/bookshop/product/The-Big-Trip-Up-Yonder-by-Kurt-Vonnegut-Jr-author/9781535304481" },
    ]
  end


end
