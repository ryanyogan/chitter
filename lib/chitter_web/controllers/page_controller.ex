defmodule ChitterWeb.PageController do
  use ChitterWeb, :controller

  plug ChitterWeb.AssignUser,
    preload: :conversations

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
