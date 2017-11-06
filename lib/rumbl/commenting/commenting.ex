defmodule Rumbl.Commenting do
  import Ecto.Query, warn: false
  alias Rumbl.Repo
  alias Rumbl.Commenting.Annotation

  def create_annotation(params, user, video_id) do
      user
      |> Ecto.build_assoc(:annotations, video_id: video_id)
      |> Annotation.changeset(params)
      |> Repo.insert()
  end

  def get_annotations(video, last_seen_id) do
    Repo.all(
      from a in Ecto.assoc(video, :annotations),
      where: a.id > ^last_seen_id,
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
      )
  end
end
