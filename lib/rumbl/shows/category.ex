defmodule Rumbl.Shows.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Shows.Category


  schema "categories" do
    field :name, :string
    has_many :videos, Rumbl.Shows.Video

    timestamps()
  end

  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
