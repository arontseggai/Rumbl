defmodule RumblWeb.PageView do
  use RumblWeb, :view

  import RumblWeb.WatchView, only: [player_id: 1]


  def truncate_description(description) do
    cond do
      String.length(description) > 130 ->
        String.slice(description, 0..130) <> "..."
      true ->
        description
    end
  end
end
