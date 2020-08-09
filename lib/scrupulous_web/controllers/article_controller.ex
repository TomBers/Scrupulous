defmodule ScrupulousWeb.ArticleController do
  use ScrupulousWeb, :controller

  alias Scrupulous.BuildHtml

  def index(conn, _params) do
    render(conn, "make_article.html")
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
