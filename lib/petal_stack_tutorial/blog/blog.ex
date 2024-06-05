defmodule PetalStackTutorial.Blog do
  use Ash.Domain,
    extensions: [
      AshJsonApi.Domain,
      AshGraphql.Domain
    ]

  resources do
    resource PetalStackTutorial.Blog.Post do
      define :create_post, action: :create
      define :list_posts, action: :read
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, action: :get, args: [:id]
    end
  end

  graphql do
    authorize? false
  end
end
