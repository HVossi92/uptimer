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
    |> normalize_address()
  end

  # Add HTTP prefix if missing and handle www
  defp normalize_address(changeset) do
    case get_change(changeset, :address) do
      nil ->
        changeset

      address ->
        # Use the normalize_url function from Websites context
        normalized_address = Uptimer.Websites.normalize_url(address)
        put_change(changeset, :address, normalized_address)
    end
  end
end
