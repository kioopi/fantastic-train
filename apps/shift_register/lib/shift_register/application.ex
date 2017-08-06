defmodule ShiftRegister.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.debug('Starting ShiftRegister App')

    # Define workers and child supervisors to be supervised
    children = [
      ShiftRegister.Server.child_spec()
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShiftRegister.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
