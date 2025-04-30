defmodule Uptimer.Websites.Website do
  use Ecto.Schema
  import Ecto.Changeset

  schema "websites" do
    field :name, :string
    field :status, :integer, default: 200
    field :address, :string
    field :thumbnail_url, :string
    field :thumbnail, :boolean, default: false

    belongs_to :user, Uptimer.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name, :address, :status, :thumbnail_url, :thumbnail, :user_id])
    |> validate_required([:name, :address, :status, :user_id])
  end
end
