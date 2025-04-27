defmodule Uptimer.WebsitesTest do
  use Uptimer.DataCase

  alias Uptimer.Websites

  describe "websites" do
    alias Uptimer.Websites.Website

    import Uptimer.WebsitesFixtures

    @invalid_attrs %{name: nil, status: nil, address: nil}

    test "list_websites/0 returns all websites" do
      website = website_fixture()
      assert Websites.list_websites() == [website]
    end

    test "get_website!/1 returns the website with given id" do
      website = website_fixture()
      assert Websites.get_website!(website.id) == website
    end

    test "create_website/1 with valid data creates a website" do
      valid_attrs = %{name: "some name", status: "some status", address: "some address"}

      assert {:ok, %Website{} = website} = Websites.create_website(valid_attrs)
      assert website.name == "some name"
      assert website.status == "some status"
      assert website.address == "some address"
    end

    test "create_website/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_website(@invalid_attrs)
    end

    test "update_website/2 with valid data updates the website" do
      website = website_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", address: "some updated address"}

      assert {:ok, %Website{} = website} = Websites.update_website(website, update_attrs)
      assert website.name == "some updated name"
      assert website.status == "some updated status"
      assert website.address == "some updated address"
    end

    test "update_website/2 with invalid data returns error changeset" do
      website = website_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_website(website, @invalid_attrs)
      assert website == Websites.get_website!(website.id)
    end

    test "delete_website/1 deletes the website" do
      website = website_fixture()
      assert {:ok, %Website{}} = Websites.delete_website(website)
      assert_raise Ecto.NoResultsError, fn -> Websites.get_website!(website.id) end
    end

    test "change_website/1 returns a website changeset" do
      website = website_fixture()
      assert %Ecto.Changeset{} = Websites.change_website(website)
    end
  end
end
