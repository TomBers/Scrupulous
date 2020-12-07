defmodule Scrupulous.BookClubTest do
  use Scrupulous.DataCase

  alias Scrupulous.BookClub

  describe "room" do
    alias Scrupulous.BookClub.Room

    @valid_attrs %{name: "some name", subtitle: "some subtitle"}
    @update_attrs %{name: "some updated name", subtitle: "some updated subtitle"}
    @invalid_attrs %{name: nil, subtitle: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> BookClub.create_room()

      room
    end

    test "list_room/0 returns all room" do
      room = room_fixture()
      assert BookClub.list_room() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert BookClub.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = BookClub.create_room(@valid_attrs)
      assert room.name == "some name"
      assert room.subtitle == "some subtitle"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookClub.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = BookClub.update_room(room, @update_attrs)
      assert room.name == "some updated name"
      assert room.subtitle == "some updated subtitle"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = BookClub.update_room(room, @invalid_attrs)
      assert room == BookClub.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = BookClub.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> BookClub.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = BookClub.change_room(room)
    end
  end

  describe "messages" do
    alias Scrupulous.BookClub.Message

    @valid_attrs %{content: "some content", parent: "some parent"}
    @update_attrs %{content: "some updated content", parent: "some updated parent"}
    @invalid_attrs %{content: nil, parent: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> BookClub.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert BookClub.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert BookClub.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = BookClub.create_message(@valid_attrs)
      assert message.content == "some content"
      assert message.parent == "some parent"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookClub.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = BookClub.update_message(message, @update_attrs)
      assert message.content == "some updated content"
      assert message.parent == "some updated parent"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = BookClub.update_message(message, @invalid_attrs)
      assert message == BookClub.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = BookClub.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> BookClub.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = BookClub.change_message(message)
    end
  end
end
