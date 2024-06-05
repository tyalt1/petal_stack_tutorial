defmodule PetalStackTutorialWeb.Router do
  use PetalStackTutorialWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PetalStackTutorialWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", PetalStackTutorialWeb do
    pipe_through :browser

    get "/", PageController, :home

    # LiveView Example
    live "/counter", Counter

    # User Login
    sign_in_route(register_path: "/register", reset_path: "/reset")
    sign_out_route AuthController
    auth_routes_for PetalStackTutorial.Accounts.User, to: AuthController
    reset_route []
  end

  scope "/api/json" do
    pipe_through :api

    forward "/", PetalStackTutorialWeb.JsonApiRouter
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:petal_stack_tutorial, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PetalStackTutorialWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview

      forward "/api/swaggerui",
              OpenApiSpex.Plug.SwaggerUI,
              path: "/api/json/open_api",
              title: "PetalStackTutorialWeb JSON-API - Swagger UI",
              default_model_expand_depth: 4
    end
  end
end

defmodule PetalStackTutorialWeb.JsonApiRouter do
  use AshJsonApi.Router,
    domains: [PetalStackTutorial.Blog],
    json_schema: "/json_schema",
    open_api: "/open_api"
end
