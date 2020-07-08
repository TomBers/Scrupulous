defmodule ScrupulousWeb.PageController do
  use ScrupulousWeb, :controller
  alias Scrupulous.UserContent
  alias Scrupulous.Graph
  alias Scrupulous.StaticContent

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def book_overview(conn, %{"book" => book}) do
    book = StaticContent.get_book_with_notes!(book)
    render(conn, "book_overview.html", book: book)
  end

  def book(conn, %{"book" => book, "page" => pageStr}) do
    current_user = Map.get(conn.assigns, :current_user)
    user_id = if current_user do
      current_user.id
      else
      nil
    end
    {page, _rem} = Integer.parse(pageStr)
    start_line = page * 50
    end_line = start_line + 50

    book = StaticContent.get_book!(book)
    notes = UserContent.get_notes_between_lines(book.id, start_line, end_line)
    lines = FileStream.read_book(book.file_name, start_line, end_line)

    render(conn, "book.html", title: book.title, book_id: book.id, notes: notes, lines: lines, next_page: page + 1, previous_page: page - 1, user_id: user_id)
  end

  def graph(conn, _params) do
    books = StaticContent.list_books()
    nodes = books
            |> Enum.map(fn(x) -> Map.put(x, :book_id, x.id) end)
            |> Enum.map(fn(x) -> Map.put(x, :id, x.title) end)
            |> Enum.map(fn(x) -> Map.put(x, :col, Graph.get_cols(x.publication_year)) end)

    edges = Graph.gen_edges(nodes)

    render(conn, "graph.html", nodes: nodes, edges: edges)
  end

  def usergraph(conn, %{"book" => book}) do
    { nodes, edges } = Scrupulous.UserGraph.graph_topic(book)
    render(conn, "graph.html", nodes: nodes, edges: edges)
  end

  def makedata(conn, _params) do
    SampleData.make_books()
    render(conn, "index.html")
  end



end
