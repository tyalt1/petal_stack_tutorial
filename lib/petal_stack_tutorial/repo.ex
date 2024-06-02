defmodule PetalStackTutorial.Repo do
  use Ecto.Repo,
    otp_app: :petal_stack_tutorial,
    adapter: Ecto.Adapters.Postgres
end
