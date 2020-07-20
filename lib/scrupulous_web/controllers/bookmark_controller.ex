defmodule ScrupulousWeb.BookmarkController do
  use ScrupulousWeb, :controller

  alias Scrupulous.UserContent
  alias Scrupulous.UserContent.Bookmark

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    bookmarks =
      if is_nil(user) do
        []
      else
        UserContent.bookmarks_for_user(user.id)
      end

    render(conn, "index.html", bookmarks: bookmarks)
  end

  def new(conn, _params) do
    changeset = UserContent.change_bookmark(%Bookmark{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    case UserContent.create_bookmark(bookmark_params) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark created successfully.")
        |> redirect(to: Routes.bookmark_path(conn, :show, bookmark))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bookmark = UserContent.get_bookmark!(id)
    render(conn, "show.html", bookmark: bookmark)
  end

  def edit(conn, %{"id" => id}) do
    bookmark = UserContent.get_bookmark!(id)
    changeset = UserContent.change_bookmark(bookmark)
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = UserContent.get_bookmark!(id)

    case UserContent.update_bookmark(bookmark, bookmark_params) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark updated successfully.")
        |> redirect(to: Routes.bookmark_path(conn, :show, bookmark))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark = UserContent.get_bookmark!(id)
    {:ok, _bookmark} = UserContent.delete_bookmark(bookmark)

    conn
    |> put_flash(:info, "Bookmark deleted successfully.")
    |> redirect(to: Routes.bookmark_path(conn, :index))
  end
end
