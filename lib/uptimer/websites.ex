defmodule Uptimer.Websites do
  @moduledoc """
  The Websites context.
  """

  import Ecto.Query, warn: false
  alias Uptimer.Repo

  alias Uptimer.Websites.Website
  alias Uptimer.Websites.Thumbnail

  @doc """
  Returns the list of websites.

  ## Examples

      iex> list_websites()
      [%Website{}, ...]

  """
  def list_websites do
    Repo.all(Website)
  end

  @doc """
  Gets a single website.

  Raises `Ecto.NoResultsError` if the Website does not exist.

  ## Examples

      iex> get_website!(123)
      %Website{}

      iex> get_website!(456)
      ** (Ecto.NoResultsError)

  """
  def get_website!(id), do: Repo.get!(Website, id)

  @doc """
  Creates a website.

  ## Examples

      iex> create_website(%{field: value})
      {:ok, %Website{}}

      iex> create_website(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(attrs \\ %{}) do
    result =
      %Website{}
      |> Website.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, website} ->
        # Generate thumbnail asynchronously
        Task.start(fn -> generate_and_save_thumbnail(website) end)
        result

      error ->
        error
    end
  end

  @doc """
  Updates a website.

  ## Examples

      iex> update_website(website, %{field: new_value})
      {:ok, %Website{}}

      iex> update_website(website, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_website(%Website{} = website, attrs) do
    result =
      website
      |> Website.changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, updated_website} ->
        # If address was changed, regenerate thumbnail
        if Map.get(attrs, "address") && website.address != updated_website.address do
          Task.start(fn -> generate_and_save_thumbnail(updated_website) end)
        end

        result

      error ->
        error
    end
  end

  @doc """
  Deletes a website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%Website{} = website) do
    # Delete all thumbnails for this website
    Thumbnail.delete_thumbnails_for_url(website.address)

    # Delete the website from database
    Repo.delete(website)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> change_website(website)
      %Ecto.Changeset{data: %Website{}}

  """
  def change_website(%Website{} = website, attrs \\ %{}) do
    Website.changeset(website, attrs)
  end

  @doc """
  Generates and saves a thumbnail for a website.
  """
  def generate_and_save_thumbnail(%Website{} = website) do
    case Thumbnail.generate_thumbnail(website.address) do
      {:ok, thumbnail_url} ->
        # Update the website with the new thumbnail URL
        result = update_website(website, %{"thumbnail_url" => thumbnail_url})

        # Broadcast event that thumbnail has been generated
        Phoenix.PubSub.broadcast(
          Uptimer.PubSub,
          "website:thumbnail:#{website.id}",
          {:website_thumbnail_generated, website.id, thumbnail_url}
        )

        result

      {:error, _reason} ->
        # Just log error and continue (already logged in Thumbnail module)
        {:error, :thumbnail_generation_failed}
    end
  end
end
