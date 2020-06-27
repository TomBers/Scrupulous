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
#    This is a hack until we have multiple books at the moment it is proxy for page
    book = pageStr
    notes = UserContent.get_notes_between_lines(book, start_line, end_line)
    lines = FileStream.read_book(start_line, end_line)
    render(conn, "book.html", book: page, notes: notes, lines: lines, next_page: page + 1, previous_page: page - 1)
  end

  def graph(conn, _params) do
    nodes = books |> Enum.map(fn(x) -> Map.put(x, :id, x.title) end) |> Enum.map(fn(x) -> Map.put(x, :node_col, get_cols(x.publication_year)) end)
    edges = gen_edges(nodes)

    render(conn, "graph.html", nodes: nodes, edges: edges)
  end

  def gen_edges(nodes) do
    nodes
    |> Enum.flat_map(fn(node) -> make_edges(node, nodes, :publication_year, &equal_func/2) end)
  end

  def make_edges(node, nodes, key, equality) do
    match_val = Map.get(node, key)
    nodes
    |> Enum.filter(fn(nde) -> nde != node and equality.(Map.get(nde, key), match_val) end)
    |> Enum.map(fn(x) -> %{id: "#{x.title}_#{node.title}", source: node.id, target: x.id} end)
  end

  def get_cols(year) do
    max = 1997
    min = 1832
    gap = year - min
    cols = [
      '#0A2F51',
      '#0E4D64',
      '#137177',
      '#188977',
      '#1D9A6C',
      '#39A96B',
      '#56B870',
      '#74C67A',
      '#99D492',
      '#DEEDCF'
    ]
#   # 17 comes from width of range (max - min) divided by the number of buckets (10) - 16.5
    Enum.at(cols, div(gap, 17))
  end

  def equal_func(a, b) do
    range = 10
#    a == b
     a >= b - range and a <= b + range
  end

  def books do
    [
      %{title: "Eugene Onegin", author: "Alexander Pushkin", country: "Russia", publication_year: 1832},
      %{title: "A Hero of Our Time", author: "Mikhail Lermontov", country: "Russia", publication_year: 1840 },
      %{title: "Fathers and Sons", author: "Ivan Turgenev", country: "Russia", publication_year: 1862},
      %{title: "The Brothers Karamazov", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1880},
      %{title: "Doctor Zhivago", author: "Boris Pasternak", country: "Russia", publication_year: 1957},
      %{title: "And Quiet Flows the Don", author: "Mikhail Sholokhov", country: "Russia", publication_year: 1928},
      %{title: "Life and Fate", author: "Vasily Grossman", country: "Russia", publication_year: 1960},
      %{title: "One Day in the Life of Ivan Denisovich", author: "Alexander Solzhenitsyn", country: "Russia", publication_year: 1962},
      %{title: "The Funeral Party", author: "Lyudmila Ulitskaya", country: "Russia", publication_year: 1997},
      %{title: "The Idiot", author: "Fyodor Dostoevsky", country: "Russia", publication_year: 1874},
    ]
  end

  #  def gen_nodes do
  #    1..10 |> Enum.map(fn(x) -> %{id: "#{x}"} end)
  #  end

  #  def gen_edges(nodes) do
  #    1..25
  #    |> Enum.map(fn(x) -> %{id: Enum.random(1..1000), source: Enum.random(nodes).id, target: Enum.random(nodes).id} end)
  #  end

end
