defmodule Slider do
  def move_up(leds) do
    { last_led, leds } = List.pop_at(leds,  length(leds)-1)
    [last_led|leds]
  end

  def move_down([first_led|leds]) do
    leds ++ [first_led]
  end
end
