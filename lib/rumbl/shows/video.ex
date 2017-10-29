defmodule Rumbl.Shows.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Shows.Video


  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    belongs_to :user, Rumbl.Accounts.User
    belongs_to :category, Rumbl.Shows.Category

    timestamps()
  end


  @required_fields ~w(url title description)a
  @optional_fields ~w(category_id)a

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> assoc_constraint(:category, [message: "this category is not valid"])
    # |> foreign_key_constraint(:category, [message: "this category is not valid"])
    |> validate_required(@required_fields)
  end
end
