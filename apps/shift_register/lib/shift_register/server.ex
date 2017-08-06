defmodule ShiftRegister.Server do
  use GenServer
  require Logger

  # TODO put these in config
  @datapin 17
  @clockpin 22
  @latchpin 24

  # Client API

  def child_spec() do  # the pins  should come as param here
    Supervisor.Spec.worker(__MODULE__, [%{ data: @datapin, clock: @clockpin, latch: @latchpin }])
  end

  def start_link(pins) do
    Logger.debug('Starting ShiftRegister GenServer')

    Logger.debug('start_link ShiftRegister.Server')
    GenServer.start_link(__MODULE__, pins, name: __MODULE__)
  end

  def write(bits) do
    GenServer.call(__MODULE__, { :write, bits })
  end

  # Karl Becks

  def init(pins) do
    Logger.debug('Init ShiftRegister.Server')

    register = ShiftRegister.get_struct(pins)

    {:ok, register}
  end

  def handle_call({ :write, bits }, _from, register) do
    ShiftRegister.write(register, bits)
    {:reply, :ok, register }
  end
end
