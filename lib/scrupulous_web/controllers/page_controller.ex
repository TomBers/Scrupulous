defmodule ScrupulousWeb.PageController do
  use ScrupulousWeb, :controller
  alias Scrupulous.UserContent
  alias Scrupulous.Graph

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
    nodes = Graph.books() |> Enum.map(fn(x) -> Map.put(x, :id, x.title) end) |> Enum.map(fn(x) -> Map.put(x, :col, Graph.get_cols(x.publication_year)) end)
    edges = Graph.gen_edges(nodes)

    render(conn, "graph.html", nodes: nodes, edges: edges)
  end



end
