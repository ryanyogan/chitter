defmodule ChitterWeb.PageController do
  use ChitterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
