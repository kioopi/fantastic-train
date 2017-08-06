defmodule SliderServerTest do
  use ExUnit.Case
  doctest Slider.Server

  test "move_up" do
    assert Slider.Server.move_up() == :ok
  end

  test "move_down" do
    assert Slider.Server.move_down() == :ok
  end

  test "set" do
    assert Slider.Server.set([0,0,1,1) == :ok
  end
end
