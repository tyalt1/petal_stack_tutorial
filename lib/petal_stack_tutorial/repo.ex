defmodule PetalStackTutorial.Repo do
  use AshPostgres.Repo,
    otp_app: :petal_stack_tutorial

  # Installs extensions that ash commonly uses
  def installed_extensions do
    ["ash-functions", "uuid-ossp", "citext"]
  end
end
