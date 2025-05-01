defmodule Uptimer.WebsiteAddressTest do
  use Uptimer.DataCase

  alias Uptimer.Websites.Website
  alias Uptimer.Websites

  test "normalizes addresses without http prefix" do
    changeset =
      Website.changeset(%Website{}, %{
        name: "Test Site",
        address: "example.com",
        status: 200,
        user_id: 1
      })

    assert changeset.valid?
    assert get_change(changeset, :address) == "https://example.com"
  end

  test "keeps addresses with http prefix" do
    changeset =
      Website.changeset(%Website{}, %{
        name: "Test Site",
        address: "http://example.com",
        status: 200,
        user_id: 1
      })

    assert changeset.valid?
    assert get_change(changeset, :address) == "http://example.com"
  end

  test "keeps addresses with https prefix" do
    changeset =
      Website.changeset(%Website{}, %{
        name: "Test Site",
        address: "https://example.com",
        status: 200,
        user_id: 1
      })

    assert changeset.valid?
    assert get_change(changeset, :address) == "https://example.com"
  end

  test "removes www from domains" do
    changeset =
      Website.changeset(%Website{}, %{
        name: "Test Site",
        address: "www.example.com",
        status: 200,
        user_id: 1
      })

    assert changeset.valid?
    assert get_change(changeset, :address) == "https://example.com"
  end

  test "removes www from domains with http prefix" do
    changeset =
      Website.changeset(%Website{}, %{
        name: "Test Site",
        address: "http://www.example.com",
        status: 200,
        user_id: 1
      })

    assert changeset.valid?
    assert get_change(changeset, :address) == "http://example.com"
  end

  test "removes www from domains with https prefix" do
    changeset =
      Website.changeset(%Website{}, %{
        name: "Test Site",
        address: "https://www.example.com",
        status: 200,
        user_id: 1
      })

    assert changeset.valid?
    assert get_change(changeset, :address) == "https://example.com"
  end

  test "handles IP addresses correctly" do
    assert Websites.normalize_url("192.168.1.1") == "https://192.168.1.1"
    assert Websites.normalize_url("192.168.1.1:8080") == "https://192.168.1.1:8080"
    assert Websites.normalize_url("http://192.168.1.1") == "http://192.168.1.1"
    assert Websites.normalize_url("https://192.168.1.1") == "https://192.168.1.1"
  end

  test "trims whitespace from address" do
    changeset =
      Website.changeset(%Website{}, %{
        name: "Test Site",
        address: "  example.com  ",
        status: 200,
        user_id: 1
      })

    assert changeset.valid?
    assert get_change(changeset, :address) == "https://example.com"
  end
end
