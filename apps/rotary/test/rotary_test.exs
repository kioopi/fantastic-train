defmodule RotaryTest do
  use ExUnit.Case
  doctest Rotary

  test "move_up function of callback_mod gets when input_mod sends interrupt" do
    Process.register(self(), :rotary_callback_test)

    clock = :rotary_pin_2
    data = :rotary_pin_1

    Rotary.InputMock.set_value(data, 0)
    Rotary.InputMock.interrupt(clock)

    assert_receive({:called, :up})
  end

  test "move_down function of callback_mod gets when input_mod sends interrupt" do
    Process.register(self(), :rotary_callback_test)

    clock = :rotary_pin_2
    data = :rotary_pin_1

    Rotary.InputMock.set_value(data, 1)
    Rotary.InputMock.interrupt(clock)

    assert_receive({:called, :down})
  end

end
