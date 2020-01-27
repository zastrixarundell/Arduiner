defmodule ArduinerWeb.Router do
  use ArduinerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ArduinerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/led", ArduinerWeb do
    pipe_through :browser

    post "/on", LedController, :create
    delete "/off", LedController, :delete
  end

  scope "/arduino", ArduinerWeb do
    pipe_through :browser

    post "/connect", ArduinoController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", ArduinerWeb do
  #   pipe_through :api
  # end
end
