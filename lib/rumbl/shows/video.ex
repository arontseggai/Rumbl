defmodule Rumbl.Shows.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.Shows.Video

  @primary_key {:id, Rumbl.Custom.Permalink, autogenerate: true}
  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :slug, :string

    belongs_to :user, Rumbl.Accounts.User
    belongs_to :category, Rumbl.Shows.Category
    has_many :annotations, Rumbl.Commenting.Annotation

    timestamps()
  end


  @required_fields ~w(url title description)a
  @optional_fields ~w(category_id)a

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> slugify_title()
    |> assoc_constraint(:category, [message: "this category is not valid"])
    |> validate_required(@required_fields)
  end

  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end

  defp slugify(string) do
    string
      |> String.downcase()
      |> String.replace(~r/[^\w-]+/u, "-")
  end

  defimpl Phoenix.Param, for: Rumbl.Shows.Video do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
