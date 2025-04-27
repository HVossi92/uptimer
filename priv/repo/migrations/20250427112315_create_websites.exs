defmodule Uptimer.Repo.Migrations.CreateWebsites do
  use Ecto.Migration

  def change do
    create table(:websites) do
      add :name, :string
      add :address, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
