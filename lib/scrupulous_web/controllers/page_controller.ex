defmodule ScrupulousWeb.PageController do
  use ScrupulousWeb, :controller

  alias Scrupulous.Graph
  alias Scrupulous.StaticContent

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def account(conn, _params) do
    render(conn, "account.html")
  end

  def demo(conn, _params) do
    render(conn, "demo.html")
  end

  def quote(conn, _params) do
    render(conn, "quote.html", quote: Scrupulous.RandomQuote.random_quote())
  end

  def book_overview(conn, %{"book" => book}) do
    book = StaticContent.get_book_with_notes!(book)
    render(conn, "book_overview.html", book: book)
  end

  def graph(conn, _params) do
    books = StaticContent.list_books()

    nodes =
      books
      |> Enum.map(fn x -> Map.put(x, :book_id, x.id) end)
      |> Enum.map(fn x -> Map.put(x, :id, x.title) end)
      |> Enum.map(fn x -> Map.put(x, :col, Graph.get_cols(x.publication_year)) end)

    edges = Graph.gen_edges(nodes)

    render(conn, "graph.html", nodes: nodes, edges: edges)
  end

  def usergraph(conn, %{"book" => book}) do
    {nodes, edges} = Scrupulous.UserGraph.graph_topic(book)
    render(conn, "graph.html", nodes: nodes, edges: edges)
  end

  def makedata(conn, %{"type" => datatype}) do
    case datatype do
      "books" -> SampleData.make_books()
      "edges" -> SampleData.make_edges()
      "resources" -> SampleData.make_resources()
    end

    render(conn, "index.html")
  end
end
