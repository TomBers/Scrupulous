defmodule Scrupulous.StaticContentTest do
  use Scrupulous.DataCase

  alias Scrupulous.StaticContent

  describe "books" do
    alias Scrupulous.StaticContent.Book

    @valid_attrs %{author: "some author", country: "some country", file_name: "some file_name", publication_year: 42, title: "some title"}
    @update_attrs %{author: "some updated author", country: "some updated country", file_name: "some updated file_name", publication_year: 43, title: "some updated title"}
    @invalid_attrs %{author: nil, country: nil, file_name: nil, publication_year: nil, title: nil}

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> StaticContent.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert StaticContent.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert StaticContent.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = StaticContent.create_book(@valid_attrs)
      assert book.author == "some author"
      assert book.country == "some country"
      assert book.file_name == "some file_name"
      assert book.publication_year == 42
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StaticContent.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, %Book{} = book} = StaticContent.update_book(book, @update_attrs)
      assert book.author == "some updated author"
      assert book.country == "some updated country"
      assert book.file_name == "some updated file_name"
      assert book.publication_year == 43
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = StaticContent.update_book(book, @invalid_attrs)
      assert book == StaticContent.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = StaticContent.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> StaticContent.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = StaticContent.change_book(book)
    end
  end
end
