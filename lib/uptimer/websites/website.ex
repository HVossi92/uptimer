defmodule Uptimer.Websites.Website do
  use Ecto.Schema
  import Ecto.Changeset

  schema "websites" do
    field :name, :string
    field :status, :string, default: "ok"
    field :address, :string
    field :thumbnail_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name, :address, :status, :thumbnail_url])
    |> validate_required([:name, :address, :status])
  end
end
