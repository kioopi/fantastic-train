defmodule Slider.Rotary do
  defstruct [:data, :clock]
  require Logger

  alias Slider.Rotary

  # TODO put these in config
  @datapin 17
  @clockpin 22

  def child_spec() do  # the pins  should come as param here
    Supervisor.Spec.worker(__MODULE__, [%{ data: @datapin, clock: @clockpin, callback_mod: Slider.Server  }])
  end

  def get_struct(%{ data: data, clock: clock, callback_mod: callback_mod }) do
    {:ok, data_pid } = Gpio.start_link(data, :input)
    {:ok, clock_pid } = Gpio.start_link(clock, :input)

    %Rotary{ data: data_pid, clock: clock_pid, clock_pin: clock, callback_mod: callback_mod }
  end

  def start_link(pins) do
    rotary = get_struct(pins)

    { :ok, spawn fn -> loop(rotary) end }
  end

  defp loop(%{ data: data, clock: clock, clock_pin: clock_pin, callback_mod: callback_mod } = rotary) do
    GIPO.set_int(clock, :rising)

    receive do
      { :gpio_interrupt, ^clock_pin, :rising } -> case read(data) do
          :up -> callback_mod.move_up()
          :down -> callback_mod.move_down()
      end
    end

    loop(rotary)
  end

  defp read(data) do
    case GIPO.read(data) do
      1 -> :up
      0 -> :down
    end
  end
end
