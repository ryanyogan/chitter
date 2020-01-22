defmodule ChitterWeb.ConversationController do
  use ChitterWeb, :controller

  alias Chitter.Chat

  require(IEx)

  plug ChitterWeb.AssignUser

  def create(conn, %{"conversation" => params}) do
  end
end
