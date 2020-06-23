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

  def graph(conn, _params) do
    nodes = gen_nodes
    edges = gen_edges(nodes)

    render(conn, "graph.html", nodes: nodes, edges: edges)
  end

  def gen_nodes do
    1..10 |> Enum.map(fn(x) -> %{id: "#{x}"} end)
  end

  def gen_edges(nodes) do
    1..25
    |> Enum.map(fn(x) -> %{id: Enum.random(1..1000), source: Enum.random(nodes).id, target: Enum.random(nodes).id} end)
  end

end
