defmodule BC do

  def run do
    msgs = [
      %{id: 1, txt: "First message", parent_id: nil},
      %{id: 8, txt: "Second message", parent_id: nil},
      %{id: 9, txt: "Reply to 2nd mesage", parent_id: 8},
      %{id: 3, txt: "First reply", parent_id: 1},
      %{id: 2, txt: "Second reply", parent_id: 1},
      %{id: 4, txt: "Reply to a reply", parent_id: 3},
      %{id: 6, txt: "Duplicate Reply to a reply", parent_id: 3},
      %{id: 5, txt: "Reply to a reply to a reply", parent_id: 4},
      %{id: 10, txt: "2nd reply to 2nd message", parent_id: 9},
      %{id: 7, txt: "This is getting silly", parent_id: 5}
    ]
      msgs
      |> Enum.reduce([], fn(msg, acc) -> calc_depth(msg, acc) end)
      |> Enum.map(fn(msg) -> Map.put(msg, :ultimate_parent, get_ultimate_parent_id(msg, msgs)) end)
      |> Enum.sort(&(&1.ultimate_parent <= &2.ultimate_parent))
  end

  def calc_depth(msg, acc) do
      parent = get_parent(msg, acc)
      acc ++ [%{id: msg.id, txt: msg.txt, depth: parent.depth + 1, parent_id: msg.parent_id}]
  end

  def get_ultimate_parent_id(msg, all) do
    if is_nil(msg.parent_id) do
      msg.id
    else
      get_ultimate_parent_id(get_parent(msg, all), all)
    end
  end

  def get_parent(msg, all) do
    Enum.find(all, %{depth: 0}, fn(ele) -> ele.id == msg.parent_id end)
  end

end
