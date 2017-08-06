defmodule Rotary.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, args) do
    import Supervisor.Spec, warn: false

    Logger.debug('Starting Rotary App')

    { :ok, callback_mod } =  Keyword.fetch(args, :callback_mod)
    { :ok, input_mod } =  Keyword.fetch(args, :input_mod)
    { :ok, datapin } =  Keyword.fetch(args, :data_pin)
    { :ok, clockpin } =  Keyword.fetch(args, :clock_pin)

    # Define workers and child supervisors to be supervised
    children = [
      Rotary.child_spec(%{
        data: datapin,
        clock: clockpin,
        callback_mod: callback_mod,
        input_mod: input_mod
      })
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rotary.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
