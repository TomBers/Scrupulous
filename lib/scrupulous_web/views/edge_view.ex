defmodule ScrupulousWeb.EdgeView do
  use ScrupulousWeb, :view
  alias ScrupulousWeb.EdgeView

  def render("index.json", %{edges: edges}) do
    %{data: render_many(edges, EdgeView, "edge.json")}
  end

  def render("show.json", %{edge: edge}) do
    %{data: render_one(edge, EdgeView, "edge.json")}
  end

  def render("edge.json", %{edge: edge}) do
    %{id: edge.id,
      label: edge.label}
  end
end
