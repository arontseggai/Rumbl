defmodule Rumbl.Accounts do
  import Ecto.Query, warn: false
  alias Rumbl.Repo

  alias Rumbl.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end


  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
