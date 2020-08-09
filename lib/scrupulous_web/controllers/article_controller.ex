defmodule ScrupulousWeb.ArticleController do
  use ScrupulousWeb, :controller

  alias Scrupulous.BuildHtml

  def index(conn, _params) do
    if is_nil(conn.assigns.current_user) do
      conn
      |> put_flash(:info, "You need to be logged in.")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      render(conn, "make_article.html")
    end
  end

  def create(conn, %{"upload" => upload}) do
    path_upload = upload["docfile"]
    #      TODO - write file to location and insert into DB?
    #   IO.inspect path_upload.filename, label: "Photo upload information"
    #  File.cp(path_upload.path, Path.absname("uploads/#{path_upload.filename}"))
    preview = BuildHtml.preview_html("#{path_upload.path}")
    render(conn, "preview.html", content: preview)
  end

end
