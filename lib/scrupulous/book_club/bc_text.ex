defmodule BCTest do

  def run do
    msgs = [
      %{id: 1, txt: "First message", parent_id: nil, children: []},
              %{id: 3, txt: "First reply", parent_id: 1, children: []},
                  %{id: 4, txt: "Reply to a reply", parent_id: 3, children: []}]
#      %{id: 2, txt: "Second msg", parent_id: nil}]
    msgs
    |> Enum.reduce([], fn(msg, acc) -> build_structure(msg, acc, msgs) end)
  end

  def is_base(msg) do
    is_nil(msg.parent_id)
  end

  def is_leaf(msg, all) do
    !is_nil(msg.parent_id) and length(get_children(msg, all)) == 0
  end

  def get_children(msg, all) do
    all |> Enum.filter(fn(m) -> m.parent_id == msg.id end)
  end

  def build_structure(msg, acc, all) do
    if is_base(msg) do
      acc ++ [msg]
    else
      existing_msg = Enum.find(acc, fn(%{id: acc_msg_id}) -> acc_msg_id == msg.parent_id end)
      if is_nil(existing_msg) do
        acc
      else
        updated_children = existing_msg.children ++ [msg]
        umsg = Map.put(existing_msg, :children, updated_children)
        indx = Enum.find_index(acc, fn(ele) -> ele.id == existing_msg.id end)
        List.update_at(acc, indx, fn(e) -> umsg end)
      end

    end

  end

end

#  def re_order_messages(msgs, all) do
#    msgs
#    |> Enum.map(fn(msg) -> add_child(msg, all, []) end)
#  end

#  def add_child(msg, all, acc) do
#    children = all |> Enum.filter(all, fn(m) -> m.parent_id == msg.id end)
#    if length(children) == 0 do
#      acc ++ [msg]
#    else
#      Enum.map(fn(child) -> add_child(child, all) end)
#    end
#  end





#  def calc_children(msg, acc, messages) do
##    For message - calc number of children
##    If no children just add to accumulator and move on
##    If it has children
#  end
#
#  def calc_all_children(msg, messages) do
#    children = Enum.filter(messages, fn(m) -> m.parent_id == msg.id end)
#    new_msg = Map.put(msg, :children, children)
#    if length(children) == 0 do
#      new_msg
#    else
#     Enum.map calc_all_children
#    end
#  end
#end