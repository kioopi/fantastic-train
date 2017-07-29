defmodule Slider.ShiftRegister do
  defstruct [:data, :clock, :latch]
  require Logger

  alias Slider.ShiftRegister

  def get_struct(%{ data: data, clock: clock, latch: latch }) do
    {:ok, data_pid } = Gpio.start_link(data, :output)
    {:ok, clock_pid } = Gpio.start_link(clock, :output)
    {:ok, latch_pid } = Gpio.start_link(latch, :output)

    %ShiftRegister{ data: data_pid, clock: clock_pid, latch: latch_pid }
  end

  def write(%ShiftRegister{latch: latch} = register, bits) do
    Logger.debug "Writing #{inspect bits}"
    Gpio.write(latch, 0)
    write_bits(register, bits)
  end

  defp write_bits(%ShiftRegister{} = register, [bit|bits]) do
    write_bit(register, bit)
    write_bits(register, bits)
  end

  defp write_bits(%ShiftRegister{latch: latch}, []) do
    Gpio.write(latch, 1)
  end

  defp write_bit(%ShiftRegister{data: data, clock: clock}, bit) do
    Gpio.write(clock, 0)
    Gpio.write(data, bit)
    Gpio.write(clock, 1)
  end
end
