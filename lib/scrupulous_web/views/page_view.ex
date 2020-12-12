defmodule ScrupulousWeb.PageView do
  use ScrupulousWeb, :view

  def get_category_links(resources, category) do
    resources
    |> Enum.filter(fn(resource) -> resource.category == category end)
  end

  def has_discussion_link(resources) do
    Enum.any?(get_category_links(resources, Scrupulous.Constants.discussion()))
  end

  def discussion_link(resources) do
    Enum.find(resources, fn(resource) -> resource.category == Scrupulous.Constants.discussion() end)
  end

end
