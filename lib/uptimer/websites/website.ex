defmodule Uptimer.Websites.Website do
  use Ecto.Schema
  import Ecto.Changeset

  schema "websites" do
    field :name, :string
    field :status, :string
    field :address, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name, :address, :status])
    |> validate_required([:name, :address, :status])
  end
end
