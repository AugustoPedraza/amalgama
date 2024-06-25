defmodule AmalgamaWeb.Router do
  use AmalgamaWeb, :router

  alias AmalgamaWeb.Plugs.LoadArticleBySlug

  pipeline :api do
    plug :accepts, ["json"]
    plug AmalgamaWeb.UserAuth
  end

  pipeline :article do
    plug LoadArticleBySlug
  end

  scope "/api", AmalgamaWeb do
    pipe_through [:api]

    post "/users/login", SessionController, :create
    post "/users", UserController, :create

    get "/articles", ArticleController, :index
    resources "/articles", ArticleController, only: [:create]
    get "/articles/:slug", ArticleController, :show
    # end

    get "/user", UserController, :current

    scope "/articles/:slug" do
      pipe_through :article

      post "/favorite", FavoriteArticleController, :create
      delete "/favorite", FavoriteArticleController, :delete
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:amalgama, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: AmalgamaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
