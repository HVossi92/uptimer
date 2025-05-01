defmodule Uptimer.Accounts.UserNotifier do
  import Swoosh.Email

  alias Uptimer.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    from_email = System.get_env("GMAIL_USERNAME") || "noreply@example.com"

    email =
      new()
      |> to(recipient)
      |> from({"Uptimer", from_email})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Welcome to Uptimer - Confirm Your Account", """

    ==============================

    Hi #{user.email},

    Thank you for signing up with Uptimer! We're excited to have you on board.

    To complete your registration and activate your account, please click the link below:

    #{url}

    This link will expire in 24 hours for security reasons.

    If you didn't create an account with us, please disregard this email.

    Best regards,
    The Uptimer Team

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
