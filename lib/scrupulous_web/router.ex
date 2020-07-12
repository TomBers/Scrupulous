defmodule ScrupulousWeb.Router do
  use ScrupulousWeb, :router

  import Phoenix.LiveView.Router
  import ScrupulousWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScrupulousWeb do
    pipe_through :browser
    resources "/books", BookController
    resources "/resources", ResourceController

    live "/reader/:book/page/:page", BookReader, layout: {ScrupulousWeb.LayoutView, :app}

    get "/", PageController, :index
    get "/scores", ScoreController, :score_board
    get "/scores/:user", ScoreController, :user_score
    get "/book/:book", PageController, :book_overview
    get "/book/:book/page/:page", PageController, :book
    get "/book/:book/resources/new/:category", ResourceController, :new_for_book
    get "/graph/", PageController, :graph
    get "/graph/:book", PageController, :usergraph
    get "/make/data", PageController, :makedata

  end

  # Other scopes may use custom stacks.
   scope "/api", ScrupulousWeb do
     pipe_through :api

     resources "/notes", NoteController, except: [:new, :edit]
     resources "/edges", EdgeController, except: [:new, :edit]
     resources "/skruples", SkrupleController, except: [:new, :edit]
   end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ScrupulousWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", ScrupulousWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ScrupulousWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ScrupulousWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
