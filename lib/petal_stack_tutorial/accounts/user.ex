defmodule PetalStackTutorial.Accounts.User do
  use Ash.Resource,
    domain: PetalStackTutorial.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  postgres do
    table "users"
    repo PetalStackTutorial.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string do
      allow_nil? false
      sensitive? true
    end
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
      end
    end

    tokens do
      enabled? true
      token_resource PetalStackTutorial.Accounts.Token
      signing_secret PetalStackTutorial.Accounts.Secrets
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
