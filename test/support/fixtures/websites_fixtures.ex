defmodule Uptimer.WebsitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Uptimer.Websites` context.
  """

  @doc """
  Generate a website.
  """
  def website_fixture(attrs \\ %{}) do
    {:ok, website} =
      attrs
      |> Enum.into(%{
        address: "some address",
        name: "some name",
        status: "some status"
      })
      |> Uptimer.Websites.create_website()

    website
  end
end
