defmodule PetalStackTutorial.Accounts do
  use Ash.Domain

  resources do
    resource PetalStackTutorial.Accounts.Token
    resource PetalStackTutorial.Accounts.User
  end
end
