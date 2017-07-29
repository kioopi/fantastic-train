defmodule Slider.Application do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, args) do
    import Supervisor.Spec, warn: false

    Logger.debug('Start App')

    { :ok, output_module } =  Keyword.fetch(args, :output_module)

    # Define workers and child supervisors to be supervised
    children = [
      Slider.Server.child_spec(output_module),
      Slider.ShiftRegister.Server.child_spec(),
      Slider.Rotary.child_spec()
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Slider.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
