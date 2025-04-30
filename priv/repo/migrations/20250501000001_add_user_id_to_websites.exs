defmodule Uptimer.Repo.Migrations.AddUserIdToWebsites do
  use Ecto.Migration

  def change do
    # Step 1: Add the column as nullable initially
    alter table(:websites) do
      add :user_id, references(:users, on_delete: :delete_all), null: true
    end

    create index(:websites, [:user_id])

    # Execute a function to assign all existing websites to the first user (or you could delete them)
    # This is a placeholder - in production you might want a more sophisticated approach
    execute """
    UPDATE websites
    SET user_id = (SELECT id FROM users ORDER BY id LIMIT 1)
    """

    # Note: SQLite doesn't support adding constraints like this.
    # For a real production app, consider using a more robust DB like PostgreSQL.
    # For now, we'll rely on application-level validation.
  end
end
