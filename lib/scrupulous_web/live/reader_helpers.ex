defmodule ScrupulousWeb.ReaderHelpers do

  alias Scrupulous.UserContent

  def make_note(_start_line, _end_line, _note, user, _book_id) when is_nil(user) do
    nil
  end

  def make_note(start_line, end_line, note, user, book_id) do
    new_note = %{start_line: start_line, end_line: end_line, note: note, user_id: user.id, book_id: book_id }
    UserContent.create_note(new_note)
  end

  def make_skruple(_note_id, user) when is_nil(user) do
    nil
  end

  def make_skruple(note_id, user) do
    new_skruple = %{note_id: note_id, user_id: user.id}
    UserContent.create_skruple(new_skruple)
  end

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
