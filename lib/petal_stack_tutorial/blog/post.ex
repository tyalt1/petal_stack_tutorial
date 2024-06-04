defmodule PetalStackTutorial.Blog.Post do
  use Ash.Resource,
    domain: PetalStackTutorial.Blog,
    data_layer: AshPostgres.DataLayer,
    extensions: []

  postgres do
    table "posts"
    repo PetalStackTutorial.Repo
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :created_at
    update_timestamp :updated_at

    attribute :title, :string do
      allow_nil? false
    end

    attribute :content, :string
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:title, :content]
    end

    update :update do
      # only edit content, not title
      accept [:content]
    end

    read :get do
      argument :id, :uuid, allow_nil?: false
      # read will only return 1 value, not a list
      get? true
      filter expr(id == ^arg(:id))
    end
  end
end