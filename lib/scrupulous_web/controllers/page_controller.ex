defmodule ScrupulousWeb.PageController do
  use ScrupulousWeb, :controller

  alias Scrupulous.Graph
  alias Scrupulous.StaticContent

  def index(conn, _params) do
    books = StaticContent.get_random_books(20)

    nodes = Graph.gen_nodes(books)
    edges = Graph.gen_edges(nodes)
    render(conn, "index.html", nodes: nodes, edges: edges)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def account(conn, _params) do
    render(conn, "account.html")
  end

  def demo(conn, _params) do
    render(conn, "demo.html")
  end

  def quotes(conn, _params) do
    render(conn, "quote.html", quote: Scrupulous.RandomQuote.random_quote())
  end

  def quotes_for_book(conn, %{"book_id" => book_id}) do
    render(conn, "quote.html", quote: Scrupulous.RandomQuote.quote_for_book(book_id))
  end

  def quotes_api(conn, _params) do
    json(conn, Scrupulous.RandomQuote.random_quote())
  end

  def quotes_book_api(conn, %{"id" => book_id}) do
    json(conn, Scrupulous.RandomQuote.quote_for_book(book_id))
  end

  def book_overview(conn, %{"book" => book}) do
    book = StaticContent.get_book_with_notes!(book)
    render(conn, "book_overview.html", book: book)
  end

  def graph(conn, _params) do
    books = StaticContent.list_books()

    nodes = Graph.gen_nodes(books)
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
