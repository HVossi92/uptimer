defmodule Uptimer.Repo.Migrations.ChangeStatusTypeInWebsites do
  use Ecto.Migration

  def change do
    # For SQLite, we need to recreate the table to change column types
    # First, create a new table with the correct schema
    create table(:websites_new) do
      add :name, :string
      add :address, :string
      # Changed from string to integer
      add :status, :integer
      add :thumbnail_url, :string
      add :thumbnail, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    # Copy data from the old table to the new one, converting the status to integer
    execute """
    INSERT INTO websites_new (id, name, address, status, thumbnail_url, thumbnail, inserted_at, updated_at)
    SELECT id, name, address, CAST(status AS INTEGER), thumbnail_url, thumbnail, inserted_at, updated_at FROM websites;
    """

    # Drop the old table
    drop table(:websites)

    # Rename the new table to the original name
    rename table(:websites_new), to: table(:websites)
  end
end
