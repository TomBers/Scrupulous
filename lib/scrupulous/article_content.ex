defmodule Scrupulous.ArticleContent do
  @moduledoc """
  The ArticleContent context.
  """

  import Ecto.Query, warn: false
  alias Scrupulous.Repo

  alias Scrupulous.ArticleContent.Article
  alias Scrupulous.ArticleContent.Note
  alias Scrupulous.ArticleContent.Skruple

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(Article)
  end

  def list_my_articles(user_id) do
    query =
      from articles in Article,
           where: articles.user_id == ^user_id
    Repo.all(query)
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id)

  def get_article_from_slug(slug) do
    query =
      from articles in Article,
           where: articles.slug == ^slug
    Repo.one(query)
  end

  def get_notes_for_article(article_id) do
    query =
      from note in Note,
           where: note.article_id == ^"#{article_id}",
           preload: [:user, :article_skruples]
    Repo.all(query)
  end


  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def create_skruple(attrs \\ %{}) do
    %Skruple{}
    |> Skruple.changeset(attrs)
    |> Repo.insert()
  end

end
