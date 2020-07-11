defmodule Scrupulous.UserContent do
  @moduledoc """
  The UserContent context.
  """

  import Ecto.Query, warn: false
  alias Scrupulous.Repo

  alias Scrupulous.UserContent.Note

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_notes do
    Repo.all(Note)
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!(123)
      %Note{}

      iex> get_note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note!(id), do: Repo.get!(Note, id)


  def get_notes_between_lines(book_id, start_line, end_line) do
    query =
      from note in Note,
           where: note.book_id == ^"#{book_id}" and note.start_line >= ^start_line and note.end_line <= ^end_line,
           preload: [:user, :skruples]
    Repo.all(query)
  end

  def get_notes_for_book(book_id) do
    query =
      from note in Note,
           where: note.book_id == ^"#{book_id}"
    Repo.all(query)
  end

#  def get_notes_between_lines(book, start_line, end_line) do
#    query =
#      from note in Note,
#           where: note.book == ^"#{book}" and note.start_line >= ^start_line and note.end_line <= ^end_line
#    Repo.all(query)
#  end


  @doc """
  Creates a note.

  ## Examples

      iex> create_note(%{field: value})
      {:ok, %Note{}}

      iex> create_note(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a note.

  ## Examples

      iex> update_note(note, %{field: new_value})
      {:ok, %Note{}}

      iex> update_note(note, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a note.

  ## Examples

      iex> delete_note(note)
      {:ok, %Note{}}

      iex> delete_note(note)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{data: %Note{}}

  """
  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end

  alias Scrupulous.UserContent.Edge

  @doc """
  Returns the list of edges.

  ## Examples

      iex> list_edges()
      [%Edge{}, ...]

  """
  def list_edges do
    Repo.all(Edge)
  end

  @doc """
  Gets a single edge.

  Raises `Ecto.NoResultsError` if the Edge does not exist.

  ## Examples

      iex> get_edge!(123)
      %Edge{}

      iex> get_edge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_edge!(id), do: Repo.get!(Edge, id)

  def get_edges_for_topic(topic) do
    query =
      from edge in Edge,
           where: edge.label == ^topic
    Repo.all(query)
  end

  def get_edges_for_book(book_id) do
    query =
      from edge in Edge,
           where: edge.source_id == ^book_id
    Repo.all(query)
  end


  @doc """
  Creates a edge.

  ## Examples

      iex> create_edge(%{field: value})
      {:ok, %Edge{}}

      iex> create_edge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_edge(attrs \\ %{}) do
    %Edge{}
    |> Edge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a edge.

  ## Examples

      iex> update_edge(edge, %{field: new_value})
      {:ok, %Edge{}}

      iex> update_edge(edge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_edge(%Edge{} = edge, attrs) do
    edge
    |> Edge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a edge.

  ## Examples

      iex> delete_edge(edge)
      {:ok, %Edge{}}

      iex> delete_edge(edge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_edge(%Edge{} = edge) do
    Repo.delete(edge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking edge changes.

  ## Examples

      iex> change_edge(edge)
      %Ecto.Changeset{data: %Edge{}}

  """
  def change_edge(%Edge{} = edge, attrs \\ %{}) do
    Edge.changeset(edge, attrs)
  end

  alias Scrupulous.UserContent.Skruple

  @doc """
  Returns the list of skruples.

  ## Examples

      iex> list_skruples()
      [%Skruple{}, ...]

  """
  def list_skruples do
    Repo.all(Skruple)
  end

  @doc """
  Gets a single skruple.

  Raises `Ecto.NoResultsError` if the Skruple does not exist.

  ## Examples

      iex> get_skruple!(123)
      %Skruple{}

      iex> get_skruple!(456)
      ** (Ecto.NoResultsError)

  """
  def get_skruple!(id), do: Repo.get!(Skruple, id)

  @doc """
  Creates a skruple.

  ## Examples

      iex> create_skruple(%{field: value})
      {:ok, %Skruple{}}

      iex> create_skruple(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_skruple(attrs \\ %{}) do
    %Skruple{}
    |> Skruple.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a skruple.

  ## Examples

      iex> update_skruple(skruple, %{field: new_value})
      {:ok, %Skruple{}}

      iex> update_skruple(skruple, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_skruple(%Skruple{} = skruple, attrs) do
    skruple
    |> Skruple.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a skruple.

  ## Examples

      iex> delete_skruple(skruple)
      {:ok, %Skruple{}}

      iex> delete_skruple(skruple)
      {:error, %Ecto.Changeset{}}

  """
  def delete_skruple(%Skruple{} = skruple) do
    Repo.delete(skruple)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking skruple changes.

  ## Examples

      iex> change_skruple(skruple)
      %Ecto.Changeset{data: %Skruple{}}

  """
  def change_skruple(%Skruple{} = skruple, attrs \\ %{}) do
    Skruple.changeset(skruple, attrs)
  end
end
