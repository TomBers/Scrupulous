defmodule ScrupulousWeb.NoteView do
  use ScrupulousWeb, :view
  alias ScrupulousWeb.NoteView

  def render("index.json", %{notes: notes}) do
    %{data: render_many(notes, NoteView, "note.json")}
  end

  def render("show.json", %{note: note}) do
    %{data: render_one(note, NoteView, "note.json")}
  end

  def render("note.json", %{note: note}) do
    %{id: note.id,
      book: note.book,
      start_line: note.start_line,
      end_line: note.end_line,
      note: note.note}
  end
end
