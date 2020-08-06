defmodule ScrupulousWeb.PageController do
  use ScrupulousWeb, :controller

  alias Scrupulous.Graph
  alias Scrupulous.StaticContent

  @prefix "line_"

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def book_overview(conn, %{"book" => book}) do
    book = StaticContent.get_book_with_notes!(book)
    render(conn, "book_overview.html", book: book)
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

  def makedata(conn, %{"type" => datatype}) do
    case datatype do
      "books" -> SampleData.make_books()
      "edges" -> SampleData.make_edges()
      "resources" -> SampleData.make_resources()
    end

    render(conn, "index.html")
  end

  def markdown(conn, _params) do



    markdown = return_markdown()

    notes = return_notes()

    {:ok, ast, []} = EarmarkParser.as_ast(markdown)

    new_ast =
      ast
      |> Enum.with_index(1)
      |> Enum.map(fn({{ele, props, content, misc}, indx} ) -> calc_node(ele, props, content, misc, indx, notes) end)

    IO.inspect(new_ast)
    html_doc = Earmark.Transform.transform(new_ast)

#    {:ok, html_doc, []} = Earmark.as_html(markdown)
    render(conn, "markdown.html", content: html_doc, prefix: @prefix,  layout: {ScrupulousWeb.LayoutView, "basic.html"})
  end

  def calc_node(ele, props, content, misc, indx, notes) do
    if Enum.any?(notes, fn(note) -> note.end_line == indx end) do
      {ele, props ++ [{"id", "#{@prefix}#{indx}"}], content ++ note_link() , misc}
    else
      {ele, props ++ [{"id", "#{@prefix}#{indx}"}], content, misc}
    end
  end

  def note_link do
    [{"a", [{"href", "#"}, {"class", "noteLink"}], ["note"], %{}}]
  end

  def return_markdown do
    case File.read("./sample.md") do
      {:ok, body} -> body
      {:error, reason} -> IO.inspect(reason); ""
    end
  end

  def return_notes do
    [
    %{start_line: 1, end_line: 20, note: "I am a note"}
    ]
  end

end
