defmodule ScrupulousWeb.PageView do
  use ScrupulousWeb, :view

  def has_note(line, notes) do
    notes
    |> Enum.any?(fn(note) -> note.end_line == line end)
  end

  def get_notes(line, notes) do
    notes
    |> Enum.filter(fn(note) -> line >= note.start_line and line <= note.end_line end)
  end

  def get_category_links(resources, category) do
    resources
    |> Enum.filter(fn(resource) -> resource.category == category end)
  end

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

  def have_skruped(user, skruples) do
    skruples
    |> Enum.any?(fn(skruple) -> skruple.user_id == user.id end)
  end

end
