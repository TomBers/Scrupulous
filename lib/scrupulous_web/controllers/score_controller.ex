defmodule ScrupulousWeb.ScoreController do
  use ScrupulousWeb, :controller
  alias Scrupulous.UserContent

  def score_board(conn, _params) do
    notes = ScoreQueries.user_notes()
    skruples = ScoreQueries.skruples()

    scores = filter_notes_and_skruples(notes, skruples) |> Enum.sort_by(&(&1.score), &>=/2)

    render(conn, "score_board.html", scores: scores)
  end

  def user_score(conn, %{"user" => user}) do
    notes = UserContent.get_notes_for_user(user)
    my_skruples = UserContent.count_skruples_for_user(user)
    note_count = length(notes)
    my_notes_scruples = Enum.reduce(notes, 0, fn (note, acc) -> acc + length(note.skruples) end)

    render(conn, "user_score.html", notes: notes, score: calc_score(note_count, my_notes_scruples, my_skruples))
  end

  def calc_score(notes, liked_my_notes, liked_others_notes) do
    note_weight = 5
    note_liked_weight = 3
    liked_note_weight = 1
    (notes * note_weight) + (liked_my_notes * note_liked_weight) + (liked_others_notes * liked_note_weight)
  end

  def filter_notes_and_skruples(notes, skruples) do
    skruples
    |> Enum.filter(fn (s) -> !is_nil(s.user_id) end)
    |> Enum.map(fn (s) -> extract_map(s, notes) end)
  end

  def extract_map(%{user_id: user_id, count: my_skruples}, notes) do
    user_notes = notes
                 |> Enum.filter(fn (n) -> n.user_id == user_id end)
    my_notes_scruples = Enum.reduce(user_notes, 0, fn (note, acc) -> acc + length(note.skruples) end)
    note_count = length(user_notes)

    %{
      user_id: user_id,
      note_count: note_count,
      my_notes_scruples: my_notes_scruples,
      my_skruples: my_skruples,
      score: calc_score(note_count, my_notes_scruples, my_skruples)
    }
  end




end
