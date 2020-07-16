defmodule ScrupulousWeb.PageView do
  use ScrupulousWeb, :view

  def get_category_links(resources, category) do
    resources
    |> Enum.filter(fn(resource) -> resource.category == category end)
  end

end
