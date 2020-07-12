defmodule ScrupulousWeb.BookReader do
  use Phoenix.LiveView

  def handle_params(%{"book" => book, "page" => page}, _uri, socket) do

    {:noreply, assign(socket, book: book, page: page)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

end
