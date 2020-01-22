defmodule ChitterWeb.Router do
  use ChitterWeb, :router
  use Pow.Phoenix.Router

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

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", ChitterWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", ChitterWeb do
    pipe_through [:browser, :protected]

    resources "/conversations", ConversationController

    live "/conversations/:conversation_id/users/:user_id",
         ConversationLive,
         as: :conversation
  end
end
