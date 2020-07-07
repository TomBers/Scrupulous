defmodule Scrupulous.UserContentTest do
  use Scrupulous.DataCase

  alias Scrupulous.UserContent

  describe "notes" do
    alias Scrupulous.UserContent.Note

    @valid_attrs %{book: "some book", end_line: 42, note: "some note", start_line: 42}
    @update_attrs %{book: "some updated book", end_line: 43, note: "some updated note", start_line: 43}
    @invalid_attrs %{book: nil, end_line: nil, note: nil, start_line: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContent.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert UserContent.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert UserContent.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = UserContent.create_note(@valid_attrs)
      assert note.book == "some book"
      assert note.end_line == 42
      assert note.note == "some note"
      assert note.start_line == 42
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContent.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = UserContent.update_note(note, @update_attrs)
      assert note.book == "some updated book"
      assert note.end_line == 43
      assert note.note == "some updated note"
      assert note.start_line == 43
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContent.update_note(note, @invalid_attrs)
      assert note == UserContent.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = UserContent.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> UserContent.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = UserContent.change_note(note)
    end
  end

  describe "notes" do
    alias Scrupulous.UserContent.Note

    @valid_attrs %{end_line: 42, note: "some note", start_line: 42}
    @update_attrs %{end_line: 43, note: "some updated note", start_line: 43}
    @invalid_attrs %{end_line: nil, note: nil, start_line: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContent.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert UserContent.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert UserContent.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = UserContent.create_note(@valid_attrs)
      assert note.end_line == 42
      assert note.note == "some note"
      assert note.start_line == 42
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContent.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = UserContent.update_note(note, @update_attrs)
      assert note.end_line == 43
      assert note.note == "some updated note"
      assert note.start_line == 43
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContent.update_note(note, @invalid_attrs)
      assert note == UserContent.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = UserContent.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> UserContent.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = UserContent.change_note(note)
    end
  end

  describe "edges" do
    alias Scrupulous.UserContent.Edge

    @valid_attrs %{label: "some label"}
    @update_attrs %{label: "some updated label"}
    @invalid_attrs %{label: nil}

    def edge_fixture(attrs \\ %{}) do
      {:ok, edge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContent.create_edge()

      edge
    end

    test "list_edges/0 returns all edges" do
      edge = edge_fixture()
      assert UserContent.list_edges() == [edge]
    end

    test "get_edge!/1 returns the edge with given id" do
      edge = edge_fixture()
      assert UserContent.get_edge!(edge.id) == edge
    end

    test "create_edge/1 with valid data creates a edge" do
      assert {:ok, %Edge{} = edge} = UserContent.create_edge(@valid_attrs)
      assert edge.label == "some label"
    end

    test "create_edge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContent.create_edge(@invalid_attrs)
    end

    test "update_edge/2 with valid data updates the edge" do
      edge = edge_fixture()
      assert {:ok, %Edge{} = edge} = UserContent.update_edge(edge, @update_attrs)
      assert edge.label == "some updated label"
    end

    test "update_edge/2 with invalid data returns error changeset" do
      edge = edge_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContent.update_edge(edge, @invalid_attrs)
      assert edge == UserContent.get_edge!(edge.id)
    end

    test "delete_edge/1 deletes the edge" do
      edge = edge_fixture()
      assert {:ok, %Edge{}} = UserContent.delete_edge(edge)
      assert_raise Ecto.NoResultsError, fn -> UserContent.get_edge!(edge.id) end
    end

    test "change_edge/1 returns a edge changeset" do
      edge = edge_fixture()
      assert %Ecto.Changeset{} = UserContent.change_edge(edge)
    end
  end
end
