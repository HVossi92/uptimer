defmodule Uptimer.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Uptimer.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}, confirmed \\ true) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Uptimer.Accounts.register_user()

    if confirmed do
      # Confirm the user immediately
      Uptimer.Repo.update!(Uptimer.Accounts.User.confirm_changeset(user))
    else
      user
    end
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
