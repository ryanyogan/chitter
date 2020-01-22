defmodule ChitterWeb.PageController do
  use ChitterWeb, :controller

  plug ChitterWeb.AssignUser,
    preload: :conversation

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
