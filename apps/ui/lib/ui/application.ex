defmodule Ui.Application do
  use Application
  require Logger

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, args) do
    import Supervisor.Spec

    Logger.debug("Starting Phoenix App ------------------------")

    { :ok, output_module } =  Keyword.fetch(args, :output_module)

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(UiWeb.Endpoint, []),
      Ui.child_spec(%{ output_module: output_module })
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ui.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
