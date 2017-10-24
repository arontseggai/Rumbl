defmodule RumblWeb.UserController do
    use RumblWeb, :controller
    plug :authenticate when action in [:index, :show]

    alias Rumbl.{Repo, Accounts.User}

    def index(conn, _params) do
        render conn, "index.html", users: Repo.all(User)
    end

    def show(conn, %{"id" => id}) do
        render conn, "show.html", user: Repo.get(User, id)
    end

    def new(conn, %{errors: errors}) do
        render conn, "new.html", user_changeset: errors
    end

    def new(conn, _params) do
        user_changeset = User.changeset(%User{}, %{})
        render conn, "new.html", user_changeset: user_changeset
    end

    def create(conn, %{"user" => user_params}) do
        user_changeset = User.registration_changeset(%User{}, user_params)

        case Repo.insert user_changeset do
          {:ok, user} ->
            conn
              |> RumblWeb.Plugs.Auth.login(user)
              |> put_flash(:info, "#{user.name} created!")
              |> redirect(to: user_path(conn, :show, user))
          {:error, reasons} ->
            new conn, %{errors: reasons}
        end
    end

    defp authenticate(conn, _opts) do
      if conn.assigns.current_user do
        conn
      else
        conn
          |> put_flash(:error, "You must be logged in to access that page")
          |> redirect(to: page_path(conn, :index))
          |> halt()
      end
    end
end
