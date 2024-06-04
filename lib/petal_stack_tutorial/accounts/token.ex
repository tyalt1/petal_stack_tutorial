defmodule PetalStackTutorial.Accounts.Token do
  use Ash.Resource,
    domain: PetalStackTutorial.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  postgres do
    table "tokens"
    repo PetalStackTutorial.Repo
  end
end
