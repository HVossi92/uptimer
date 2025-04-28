defmodule Uptimer.Repo.Migrations.AddThumbnailPreferenceToWebsites do
  use Ecto.Migration

  def change do
    alter table(:websites) do
      add :thumbnail, :boolean, default: false
    end
  end
end
