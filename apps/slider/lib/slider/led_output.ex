defmodule Slider.LEDOutput do
  @behaviour Slider.Output

  ## TODO this needs to come from other umbrell project
  def update(leds) do
    ShiftRegister.Server.write(leds)
  end
end
