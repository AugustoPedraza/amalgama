defmodule Amalgama.Accounts.Validators.UniqueEmail do
  use Vex.Validator

  alias Amalgama.Accounts

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: fn value -> !email_registered?(value) end,
      message: "has already been taken"
    )
  end

  defp email_registered?(username) do
    case Accounts.user_by_email(username) do
      nil -> false
      _ -> true
    end
  end
end
