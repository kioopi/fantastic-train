defmodule Rotary.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.debug('Starting Rotary App')

    datapin = Application.get_env(:rotary, :datapin)
    clockpin = Application.get_env(:rotary, :clockpin)

    # Define workers and child supervisors to be supervised
    children = [
      Rotary.child_spec(%{ data: datapin, clock: clockpin, callback_mod: Slider.Server })

      # Starts a worker by calling: Rotary.Worker.start_link(arg1, arg2, arg3)
      # worker(Rotary.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rotary.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
