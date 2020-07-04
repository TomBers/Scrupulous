defmodule Scrupulous.UserGraph do
  alias Scrupulous.UserContent
  alias Scrupulous.StaticContent

  @col '#D3D3D3'

  def graph_topic(book_id) do
    edges = UserContent.get_edges_for_book(book_id)
    book_ids =
      edges
      |> Enum.flat_map(fn(edge) -> [edge.source_id, edge.target_id] end)
      |> MapSet.new()
      |> MapSet.to_list()


    books = StaticContent.list_books_from_ids(book_ids)
    edges_map =
      edges
      |> Enum.map(fn(edge) -> %{id: "#{edge.id}", source: get_book_title(edge.source_id, books), target: get_book_title(edge.target_id, books), col: @col, edge_width: 2} end)
    { add_node_info(books), edges_map }
  end

  def get_book_title(id, books) do
    book =
      books
      |> Enum.find(fn(book) -> book.id == id end)
    book.title
  end

  def add_node_info(nodes) do
    nodes
      |> Enum.map(fn(x) -> Map.put(x, :book_id, x.id) end)
      |> Enum.map(fn(x) -> Map.put(x, :id, x.title) end)
      |> Enum.map(fn(x) -> Map.put(x, :col, @col) end)
  end

end
