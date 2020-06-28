defmodule Scrupulous.Graph do
  @moduledoc false

  @year_col '#39A96B'
  @country_col '#DEEDCF'
  @author_col '#0A2F51'

  def gen_edges(nodes) do
    year = nodes
            |> Enum.flat_map(fn(node) -> make_edges(node, nodes, :publication_year, &range_func/3, @year_col) end)
            |> Enum.reduce([], fn(x, acc) -> remove_dupes(x, acc) end)

    country = nodes
              |> Enum.flat_map(fn(node) -> make_edges(node, nodes, :country, &eql_func/3, @country_col) end)
              |> Enum.reduce([], fn(x, acc) -> remove_dupes(x, acc) end)

    author = nodes
             |> Enum.flat_map(fn(node) -> make_edges(node, nodes, :author, &eql_func/3, @author_col) end)
             |> Enum.reduce([], fn(x, acc) -> remove_dupes(x, acc) end)

    year ++ country ++ author
  end

  def make_edges(node, nodes, key, equality, col) do
    match_val = Map.get(node, key)
    nodes
    |> Enum.filter(fn(nde) -> nde != node and equality.(Map.get(nde, key), match_val, 10) end)
    |> Enum.map(fn(x) -> %{id: "#{to_string(key)}_#{x.title}_#{node.title}", source: node.id, target: x.id, col: col} end)
  end

  def remove_dupes(edge, acc) do
    if Enum.any?(acc, fn(existing_edge) -> edge.source == existing_edge.target and edge.target == existing_edge.source end) do
      acc
      else
      acc ++ [edge]
    end
  end


  def get_cols(year) do
    max = 1880
    min = 1831
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
    Enum.at(cols, div(gap, 5))
  end

  def range_func(a, b, range \\ 10) do
    a >= b - range and a <= b + range
  end

  def eql_func(a, b, _range) do
    a == b
  end

end
