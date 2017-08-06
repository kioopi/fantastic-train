defmodule Rotary.InputMock do
  use GenServer

  def start_link(pin, :input) do
    GenServer.start_link(__MODULE__, %{ value: 0, pin: pin}, name: :"rotary_pin_#{pin}")
  end

  def set_int(pid, :falling) do
    GenServer.call(pid, :set_int)
  end

  def interrupt(pid) do
    GenServer.cast(pid, {:interrupt})
  end

  def set_value(pid, value) do
    GenServer.cast(pid, {:set_value, value})
  end

  def read(pid) do
    GenServer.call(pid, :read)
  end

  def handle_call(:set_int, { pid, _tag }, state) do
    {:reply, :ok, Map.put(state, :caller, pid)}
  end

  def handle_call(:read, _from, %{ value: value, pin: pin } = state) do
    {:reply, value, state}
  end

  def handle_cast({:set_value, value}, %{ pin: pin } = state) do
    {:noreply, Map.put(state, :value, value) }
  end

  def handle_cast({:interrupt}, %{ caller: caller, pin: pin } = state) when is_pid(caller) do
    send(caller, { :gpio_interrupt, pin, :falling })
    {:noreply, state}
  end
end

defmodule Rotary.CallbackMock do
  def move_up() do
    send(:rotary_callback_test, {:called, :up})
  end

  def move_down() do
    send(:rotary_callback_test, {:called, :down})
  end
end
