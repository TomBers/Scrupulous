defmodule ScrupulousWeb.ScoreView do
  use ScrupulousWeb, :view

  @lines_per_page 300

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

  def calc_scruples_on_notes(notes) do
    notes
    |> Enum.reduce(0, fn(note, acc) -> acc + length(note.skruples) end)
  end

  def get_note_url(note) do
      "/reader/#{note.book.id}/page/#{div(note.end_line, @lines_per_page)}?note=#{note.id}"
  end

end
