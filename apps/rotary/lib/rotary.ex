defmodule Rotary do
  defstruct [:data, :clock, :clock_pin, :callback_mod, :input_mod]
  require Logger

  def child_spec(%{ data: _datapin, clock: _clockpin, callback_mod: _callback_mod, input_mod: _input_mod } = args) do
    Logger.debug('Getting Rotary spec')
    Supervisor.Spec.worker(__MODULE__, [args])
  end

  def start_link(args) do
    Logger.debug('Starting Rotary Process')

    rotary = get_struct(args)

    { :ok, spawn fn -> args.input_mod.set_int(rotary.clock, :falling); loop(rotary) end }
  end

  defp get_struct(%{ data: data, clock: clock, callback_mod: callback_mod, input_mod: input_mod }) do
    {:ok, data_pid } = input_mod.start_link(data, :input)
    {:ok, clock_pid } = input_mod.start_link(clock, :input)

    %Rotary{
      data: data_pid,
      clock: clock_pid,
      clock_pin: clock,
      callback_mod: callback_mod,
      input_mod: input_mod
    }
  end

  defp loop(%{ data: data, clock: clock, clock_pin: clock_pin, callback_mod: callback_mod, input_mod: input_mod } = rotary) do
    receive do
      { :gpio_interrupt, ^clock_pin, :falling } -> if is_low(input_mod, clock) do
        case read(input_mod, data) do
          :up -> callback_mod.move_up()
          :down -> callback_mod.move_down()
        end
      end
    end

    loop(rotary)
  end

  defp is_low(input_mod, clock) when is_pid(clock) do
    case input_mod.read(clock) do
      0 -> true
      1 -> false
    end
  end

  defp read(input_mod, data) when is_pid(data) do
    case input_mod.read(data) do
      0 -> :up
      1 -> :down
    end
  end
end
