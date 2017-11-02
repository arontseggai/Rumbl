defmodule Rumbl.Commenting.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Commenting.Annotation

  schema "annotations" do
      field :body, :string
      field :at, :integer

      belongs_to :user, Rumbl.Accounts.User
      belongs_to :video, Rumbl.Shows.Video

      timestamps()
  end


  @required_fields ~w(body at)a
  @optional_fields ~w()a

  def changeset(%Annotation{} = annotation, attrs) do
    annotation
      |> cast(attrs, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
  end
end
