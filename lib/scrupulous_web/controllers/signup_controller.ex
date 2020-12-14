defmodule ScrupulousWeb.SignupController do
  use ScrupulousWeb, :controller

  alias Scrupulous.BookClub
  alias Scrupulous.BookClub.Signup

  def index(conn, _params) do
    signups = BookClub.list_signups()
    render(conn, "index.html", signups: signups)
  end

  def new(conn, _params) do
    changeset = BookClub.change_signup(%Signup{feature: "BookClub"})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"signup" => signup_params}) do
    case BookClub.create_signup(signup_params) do
      {:ok, _signup} ->
        conn
        |> put_flash(:info, "Thank you, we will get in contact.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    signup = BookClub.get_signup!(id)
    render(conn, "show.html", signup: signup)
  end

  def edit(conn, %{"id" => id}) do
    signup = BookClub.get_signup!(id)
    changeset = BookClub.change_signup(signup)
    render(conn, "edit.html", signup: signup, changeset: changeset)
  end

  def update(conn, %{"id" => id, "signup" => signup_params}) do
    signup = BookClub.get_signup!(id)

    case BookClub.update_signup(signup, signup_params) do
      {:ok, signup} ->
        conn
        |> put_flash(:info, "Signup updated successfully.")
        |> redirect(to: Routes.signup_path(conn, :show, signup))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", signup: signup, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    signup = BookClub.get_signup!(id)
    {:ok, _signup} = BookClub.delete_signup(signup)

    conn
    |> put_flash(:info, "Signup deleted successfully.")
    |> redirect(to: Routes.signup_path(conn, :index))
  end
end
