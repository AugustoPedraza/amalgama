defmodule Amalgama.CommandedApp do
  use Commanded.Application, otp_app: :amalgama

  router(Amalgama.Router)
end
