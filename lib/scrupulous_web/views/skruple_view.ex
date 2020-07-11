defmodule ScrupulousWeb.SkrupleView do
  use ScrupulousWeb, :view
  alias ScrupulousWeb.SkrupleView

  def render("index.json", %{skruples: skruples}) do
    %{data: render_many(skruples, SkrupleView, "skruple.json")}
  end

  def render("show.json", %{skruple: skruple}) do
    %{data: render_one(skruple, SkrupleView, "skruple.json")}
  end

  def render("skruple.json", %{skruple: skruple}) do
    %{id: skruple.id}
  end
end
