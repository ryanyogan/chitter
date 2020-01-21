defmodule ChitterWeb.Router do
  use ChitterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChitterWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/conversations/:conversation_id/users/:user_id",
         ConversationLive
  end
end
