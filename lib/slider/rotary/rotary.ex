defmodule Slider.Rotary do
  defstruct [:data, :clock, :clock_pin, :callback_mod]
  require Logger

  alias Slider.Rotary

  # TODO put these in config
  @datapin 2
  @clockpin 3

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

    { :ok, spawn fn -> Gpio.set_int(rotary.clock, :falling); loop(rotary) end }
  end

  defp loop(%{ data: data, clock: clock, clock_pin: clock_pin, callback_mod: callback_mod } = rotary) do
    receive do
      { :gpio_interrupt, ^clock_pin, :falling } -> if is_low(clock) do
        case read(data) do
          :up -> callback_mod.move_up()
          :down -> callback_mod.move_down()
        end
      end
    end

    loop(rotary)
  end

  defp is_low(clock) do
    case Gpio.read(clock) do
      0 -> true
      1 -> false
    end
  end

  defp read(data) do
    case Gpio.read(data) do
      0 -> :up
      1 -> :down
    end
  end
end
