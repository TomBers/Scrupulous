defmodule SampleEdges do
  alias Scrupulous.UserContent

  def gen_edge do

    source_id = Enum.random(1..17)
    target_id = Enum.random(1..17)
    IO.inspect(source_id)
    IO.inspect(target_id)
    %{label: "test", source_id: source_id, target_id: target_id}
  end

  def make_edge do
    edge = gen_edge()
    UserContent.create_edge(edge)
  end

end
