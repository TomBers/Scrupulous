defmodule ScrupulousWeb.ScoreView do
  use ScrupulousWeb, :view

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

  def calc_scruples_on_notes(notes) do
    notes
    |> Enum.reduce(0, fn(note, acc) -> acc + length(note.skruples) end)
  end

end
