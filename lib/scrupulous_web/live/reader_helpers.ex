defmodule ScrupulousWeb.ReaderHelpers do

  def format_email(email) do
    email
    |> String.split("@")
    |> List.first
  end

  def get_notes(line, notes, param_note) when is_nil(param_note) do
    notes
    |> Enum.filter(fn(note) -> line >= note.start_line and line <= note.end_line end)
  end

  def get_notes(_line, notes, param_note) do
    notes
    |> Enum.filter(fn(note) -> note.id == param_note.id end)
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

  def get_line_class(line, notes,  open_note, param_note) do
    if line_class_conditions(line, notes,  open_note, param_note) do
      "line selected"
    else
      "line"
    end
  end

  defp line_class_conditions(line, notes,  open_note, param_note) when is_nil(param_note) do
    Enum.any?(
      notes,
      fn (note) ->
        open_note >= note.start_line and open_note <= note.end_line and line >= note.start_line and line <= note.end_line
      end
    )
  end

  defp line_class_conditions(line, _notes, _open_note, param_note) do
    line >= param_note.start_line and line <= param_note.end_line
  end

end
