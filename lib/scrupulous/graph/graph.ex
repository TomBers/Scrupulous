defmodule Scrupulous.Graph do
  @moduledoc false

  @year_col '#D3D3D3'
  @country_col '#D3D3D3'
  @author_col '#778899'

  @year_range 10

  def gen_edges(nodes) do
    year = nodes
            |> Enum.flat_map(fn(node) -> make_edges(node, nodes, :publication_year, &range_func/3, @year_col, 2) end)
            |> Enum.reduce([], fn(x, acc) -> remove_dupes(x, acc) end)

    country = nodes
              |> Enum.flat_map(fn(node) -> make_edges(node, nodes, :country, &eql_func/3, @country_col, 1) end)
              |> Enum.reduce([], fn(x, acc) -> remove_dupes(x, acc) end)

    author = nodes
             |> Enum.flat_map(fn(node) -> make_edges(node, nodes, :author, &eql_func/3, @author_col, 5) end)
             |> Enum.reduce([], fn(x, acc) -> remove_dupes(x, acc) end)

    year ++ country ++ author
  end

  def make_edges(node, nodes, key, equality, col, edge_width) do
    match_val = Map.get(node, key)
    nodes
    |> Enum.filter(fn(nde) -> nde != node and equality.(Map.get(nde, key), match_val, @year_range) end)
    |> Enum.map(fn(x) -> %{id: "#{to_string(key)}_#{x.title}_#{node.title}", source: node.id, target: x.id, col: col, edge_width: edge_width} end)
  end

  def remove_dupes(edge, acc) do
    if Enum.any?(acc, fn(existing_edge) -> edge.source == existing_edge.target and edge.target == existing_edge.source end) do
      acc
      else
      acc ++ [edge]
    end
  end

  def get_cols(year) when is_nil(year) do
    '#0A2F51'
  end

  def get_cols(year) do
    # max = 1954
    min = 1864
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
#    TODO - make this respect the date range - at the moment a bit of a hack
    Enum.at(cols, div(gap, 10))
  end

  def range_func(a, b, _range) when is_nil(a) or is_nil(b) do
    false
  end

  def range_func(a, b, range) do
    a >= b - range and a <= b + range
  end

  def eql_func(a, b, _range) do
    a == b
  end

end
