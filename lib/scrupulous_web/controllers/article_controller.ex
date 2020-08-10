defmodule ScrupulousWeb.ArticleController do
  use ScrupulousWeb, :controller

  alias Scrupulous.ArticleContent
  alias Scrupulous.ArticleContent.Article
  alias Scrupulous.BuildHtml

  plug :ensure_logged_in_user
  plug :check_article_ownership when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    user = conn.assigns.current_user
    articles = ArticleContent.list_my_articles(user.id)
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = ArticleContent.change_article(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    user = conn.assigns.current_user
    article = article_from_params(article_params, user)
    case ArticleContent.create_article(article) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def article_from_params(params, user) do
    title = params["title"]
    file = params["docfile"]
    case File.read(file.path) do
      {:ok, body} -> %{user_id: user.id, title: title, content: body, slug: title |> String.downcase |> String.replace(" ", "-") }
      {:error, _reason} -> %{}
    end
  end

  def show(conn, %{"id" => id}) do
    article = conn.assigns.article
    content = BuildHtml.preview_html(article)
    render(conn, "show.html", article: article, content: content)
  end

  def edit(conn, %{"id" => id}) do
    article = conn.assigns.article
    changeset = ArticleContent.change_article(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = conn.assigns.article

    user = conn.assigns.current_user
    updated_article = article_from_params(article_params, user)

    case ArticleContent.update_article(article, updated_article) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: Routes.article_path(conn, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = conn.assigns.article
    {:ok, _article} = ArticleContent.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: Routes.article_path(conn, :index))
  end

  defp ensure_logged_in_user(conn, _opts) do
    if is_nil(conn.assigns.current_user) do
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end

  defp check_article_ownership(conn, _opts) do
    id = get_path_params(conn.path_params)
    article = ArticleContent.get_article!(id)
    if article.user_id == conn.assigns.current_user.id do
      conn
      |> assign(:article, article)
    else
      conn
      |> put_flash(:error, "Article not found")
      |> redirect(to: "/")
      |> halt()
    end
  end

  def get_path_params(%{"id" => id}), do: id

end


