defmodule ScrupulousWeb.ReaderHelpers do

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

  def get_notes(line, notes) do
    notes
    |> Enum.filter(fn(note) -> line >= note.start_line and line <= note.end_line end)
  end

  def have_skruped(user, skruples) do
    skruples
    |> Enum.any?(fn(skruple) -> skruple.user_id == user.id end)
  end

  def is_note_open(line, open_note) do
    line == open_note
  end

  def has_note(line, notes) do
    notes
    |> Enum.any?(fn(note) -> note.end_line == line end)
  end

  def get_note_class(line, open_note) do
    if is_note_open(line, open_note) do
      "note activeIcon"
    else
      "note"
    end
  end

  def get_line_class(line, open_note, notes) do
    if Enum.any?(
         notes,
         fn (note) ->
           open_note >= note.start_line and open_note <= note.end_line and line >= note.start_line and line <= note.end_line
         end
       ) do
      "line selected"
    else
      "line"
    end
  end

end
