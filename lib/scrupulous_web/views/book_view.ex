defmodule ScrupulousWeb.BookView do
  use ScrupulousWeb, :view

  def letters do
    letters = for n <- ?a..?z, do: << n :: utf8 >>
  end

end
