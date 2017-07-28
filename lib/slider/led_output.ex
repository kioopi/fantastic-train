defmodule Slider.LEDOutput do
  @behaviour Slider.Output

  def update(leds) do
    Slider.ShiftRegister.Server.write(leds)
  end
end
