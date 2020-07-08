defmodule ScrupulousWeb.ResourceController do
  use ScrupulousWeb, :controller

  alias Scrupulous.StaticContent
  alias Scrupulous.StaticContent.Resource

  def index(conn, _params) do
    resources = StaticContent.list_resources()
    render(conn, "index.html", resources: resources)
  end

  def new(conn, _params) do
    changeset = StaticContent.change_resource(%Resource{})
    render(conn, "new.html", changeset: changeset)
  end

  def new_for_book(conn, %{"book" => book_id, "category" => category}) do
    current_user = Map.get(conn.assigns, :current_user)
    user_id = if current_user do
      current_user.id
    else
      nil
    end
    changeset = StaticContent.change_resource(%Resource{book_id: book_id, category: category, user_id: user_id})
    render(conn, "new.html", changeset: changeset, book_id: book_id)
  end

  def create(conn, %{"resource" => resource_params}) do
    case StaticContent.create_resource(resource_params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Resource created successfully.")
        |> redirect(to: Routes.page_path(conn, :book_overview, Map.get(resource_params, "book_id")))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    resource = StaticContent.get_resource!(id)
    render(conn, "show.html", resource: resource)
  end

  def edit(conn, %{"id" => id}) do
    resource = StaticContent.get_resource!(id)
    changeset = StaticContent.change_resource(resource)
    render(conn, "edit.html", resource: resource, changeset: changeset)
  end

  def update(conn, %{"id" => id, "resource" => resource_params}) do
    resource = StaticContent.get_resource!(id)

    case StaticContent.update_resource(resource, resource_params) do
      {:ok, resource} ->
        conn
        |> put_flash(:info, "Resource updated successfully.")
        |> redirect(to: Routes.resource_path(conn, :show, resource))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", resource: resource, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource = StaticContent.get_resource!(id)
    {:ok, _resource} = StaticContent.delete_resource(resource)

    conn
    |> put_flash(:info, "Resource deleted successfully.")
    |> redirect(to: Routes.resource_path(conn, :index))
  end
end
