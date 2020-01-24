defmodule ChitterWeb.AssignUser do
  import Plug.Conn

  alias Chitter.Auth.User
  alias Chitter.Repo

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, params) do
    case Pow.Plug.current_user(conn) do
      %User{} = user ->
        assign(conn, :current_user, Repo.preload(user, params[:preload] || []))

      _ ->
        assign(conn, :current_user, nil)
    end
  end
end
