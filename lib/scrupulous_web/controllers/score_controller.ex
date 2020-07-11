defmodule ScrupulousWeb.ScoreController do
  use ScrupulousWeb, :controller
  alias Scrupulous.UserContent

  def user_score(conn, %{"user" => user}) do
    notes = UserContent.get_notes_for_user(user)
    my_skruples = UserContent.count_skruples_for_user(user)
    note_count = length(notes)
    my_notes_scruples = Enum.reduce(notes, 0, fn(note, acc) -> acc + length(note.skruples) end)

    render(conn, "user_score.html", notes: notes, score: calc_score(note_count, my_notes_scruples, my_skruples))
  end

  def calc_score(notes, liked_my_notes, liked_others_notes) do
    note_weight = 5
    note_liked_weight = 3
    liked_note_weight = 1
    (notes * note_weight) + (liked_my_notes * note_liked_weight) + (liked_others_notes * liked_note_weight)
  end



end
