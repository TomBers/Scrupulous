defmodule ScrupulousWeb.ArticleController do
  use ScrupulousWeb, :controller

  alias Scrupulous.ArticleContent
  alias Scrupulous.ArticleContent.Article
  alias Scrupulous.BuildHtml

  def index(conn, _params) do
    articles = ArticleContent.list_articles()
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
    article = ArticleContent.get_article!(id)
    content = BuildHtml.preview_html(article)
    render(conn, "show.html", article: article, content: content)
  end

  def edit(conn, %{"id" => id}) do
    article = ArticleContent.get_article!(id)
    changeset = ArticleContent.change_article(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = ArticleContent.get_article!(id)

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
    article = ArticleContent.get_article!(id)
    {:ok, _article} = ArticleContent.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: Routes.article_path(conn, :index))
  end
end
