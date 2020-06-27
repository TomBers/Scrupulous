defmodule ScrupulousWeb.PageView do
  use ScrupulousWeb, :view

  def has_note(line, notes) do
    notes
    |> Enum.any?(fn(note) -> note.end_line == line end)
  end
end
