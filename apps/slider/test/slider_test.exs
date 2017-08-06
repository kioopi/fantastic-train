defmodule SliderTest do
  use ExUnit.Case
  doctest Slider

  test "move_up" do
    assert Slider.move_up([0,1,0,0]) == [0,0,1,0]
    assert Slider.move_up([0,0,0,1]) == [1,0,0,0]
  end

  test "move_down" do
    assert Slider.move_down([0,1,0,0]) == [1,0,0,0]
    assert Slider.move_down([0,0,0,1]) == [0,0,1,0]
    assert Slider.move_down([1,0,0,0]) == [0,0,0,1]
  end

  test "set" do
    assert Slider.set([0,1,0,0]) == [0,1,0,0]
  end
end
