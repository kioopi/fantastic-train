defmodule SliderServerTest do
  use ExUnit.Case
  doctest Slider.Server

  test "move_up" do
    assert Slider.Server.move_up() == :ok
  end

  test "move_down" do
    assert Slider.Server.move_down() == :ok
  end
end
