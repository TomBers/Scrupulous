defmodule BC do

  def run do
    msgs = [
      %{id: 1, txt: "First message", parent_id: nil, children: nil},
      %{id: 2, txt: "Second reply", parent_id: 1, children: nil},
      %{id: 3, txt: "First reply", parent_id: 1, children: nil},
      %{id: 4, txt: "Reply to a reply", parent_id: 3, children: nil},
      %{id: 6, txt: "Duplicate Reply to a reply", parent_id: 3, children: nil},
      %{id: 5, txt: "Reply to a reply to a reply", parent_id: 4, children: nil}
    ]

    sorted =
      msgs
      |> Enum.reduce([], fn(msg, acc) -> calc_depth(msg, acc) end)
      |> Enum.sort(&(&1.depth <= &2.depth))
  end

  def calc_depth(msg, acc) do
      parent = Enum.find(acc, %{depth: -1}, fn(ele) -> ele.id == msg.parent_id end)
      acc ++ [%{id: msg.id, txt: msg.txt, depth: parent.depth + 1}]
  end

  def eat_all_msgs(msg, acc, all) do
    acc ++ [%{txt: msg.txt, children: get_at_depth(msg.depth + 1, all)}]
  end

  def get_at_depth(depth, all) do
    all
    |> Enum.filter(fn(ele) -> ele.depth == depth end)
    |> Enum.map(fn(ele) -> %{txt: ele.txt} end)
  end

end
