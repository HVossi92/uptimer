defmodule Uptimer.Repo.Migrations.AddThumbnailUrlToWebsites do
  use Ecto.Migration

  def change do
    alter table(:websites) do
      add :thumbnail_url, :string
    end
  end
end
