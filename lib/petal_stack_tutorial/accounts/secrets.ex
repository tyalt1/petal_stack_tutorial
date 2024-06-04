defmodule PetalStackTutorial.Accounts.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], PetalStackTutorial.Accounts.User, _) do
    case Application.fetch_env(:petal_stack_tutorial, PetalStackTutorialWeb.Endpoint) do
      {:ok, endpoint_config} ->
        Keyword.fetch(endpoint_config, :secret_key_base)

      :error ->
        :error
    end
  end
end
