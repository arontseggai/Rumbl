defmodule RumblWeb.UserController do
    use RumblWeb, :controller
    plug :authenticate_user when action in [:index, :show]

    alias Rumbl.{Accounts, Accounts.User}

    def index(conn, _params) do
        render conn, "index.html", users: Accounts.list_users
    end

    def show(conn, %{"id" => id}) do
        render conn, "show.html", user: Accounts.get_user!(id)
    end

    def new(conn, %{errors: errors}) do
        render conn, "new.html", user_changeset: errors
    end

    def new(conn, _params) do
        render conn, "new.html", user_changeset: Accounts.change_user(%User{})
    end

    def create(conn, %{"user" => user_params}) do
        case Accounts.create_user user_params do
          {:ok, user} ->
            conn
              |> RumblWeb.Plugs.Auth.login(user)
              |> put_flash(:info, "#{user.name} created!")
              |> redirect(to: user_path(conn, :show, user))
          {:error, reasons} ->
            new conn, %{errors: reasons}
        end
    end
end
