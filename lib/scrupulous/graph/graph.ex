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

  def range_func(a, b, range \\ 10) do
    a >= b - range and a <= b + range
  end

  def eql_func(a, b, _range) do
    a == b
  end

  def books do
    [
      %{title: "Eugene Onegin", author: "Alexander Pushkin", country: "Russia", publication_year: 1832},
      %{title: "The Captains Daughter", author: "Alexander Pushkin", country: "Russia", publication_year: 1836},
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
