defmodule Slider.Server do
  use GenServer
  require Logger

  # Client API

  def child_spec(output_module) do
    Supervisor.Spec.worker(__MODULE__, [%{ leds: [0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0], output_module: output_module}])
  end

  def start_link(%{ leds: leds, output_module: output_module }) do
    Logger.debug('start_link Slider.Server')
    GenServer.start_link(__MODULE__, [leds, output_module], name: __MODULE__)
  end

  def move_up() do
    GenServer.call(__MODULE__, :move_up)
  end

  def move_down() do
    GenServer.call(__MODULE__, :move_down)
  end

  # Karl Becks

  def init([leds, output]) do
    Logger.debug('Init Slider.Server')
    {:ok, %{ leds: leds, output: output }}
  end

  def handle_call(:move_up, _from, %{ leds: leds } = state) do
    {:reply, :ok, update_leds(Slider.move_up(leds), state)}
  end

  def handle_call(:move_down, _from, %{ leds: leds } = state) do
    {:reply, :ok, update_leds(Slider.move_down(leds), state)}
  end

  defp update_leds(leds, state) do
    apply(state.output, :update, [leds])

    %{state|leds: leds}
  end
end
