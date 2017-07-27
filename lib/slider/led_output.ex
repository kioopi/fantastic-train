defmodule Slider.LEDOutput do
  @behaviour Slider.Output

  def update(leds) do
    Slider.ShiftRegister.Server.write(leds)
  end
end

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
    Logger.debug "latch"
    Gpio.write(latch, 1)
  end

  defp write_bit(%ShiftRegister{data: data, clock: clock}, bit) do
    Logger.debug "Writing bit #{bit}"
    Gpio.write(clock, 0)
    Gpio.write(data, bit)
    Gpio.write(clock, 1)
  end
end

defmodule Slider.ShiftRegister.Server do
  use GenServer
  require Logger
  alias Slider.ShiftRegister

  # TODO put these in config
  @datapin 17
  @clockpin 22
  @latchpin 24

  # Client API

  def child_spec() do  # the pins  should come as param here
    Supervisor.Spec.worker(__MODULE__, [%{ data: @datapin, clock: @clockpin, latch: @latchpin }])
  end

  def start_link(pins) do
    Logger.debug('start_link Slider.ShiftRegister.Server')
    GenServer.start_link(__MODULE__, pins, name: __MODULE__)
  end

  def write(bits) do
    GenServer.call(__MODULE__, { :write, bits })
  end

  # Karl Becks

  def init(pins) do
    Logger.debug('Init Slider.ShiftRegister.Server')

    register = ShiftRegister.get_struct(pins)

    {:ok, register}
  end

  def handle_call({ :write, bits }, _from, register) do
    ShiftRegister.write(register, bits)
    {:reply, :ok, register }
  end
end
