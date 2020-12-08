defmodule ScrupulousWeb.BookClub do
  use Phoenix.LiveView
  alias Scrupulous.BookClub

  def handle_params(params, _uri, socket) do
    room = BookClub.get_room_with_messages!(1)

    messages = BC.run()

    {:noreply, assign(socket, room: room, messages: messages)}
  end


  def mount(_params, _session, socket) do
    {:ok, socket}
  end

end