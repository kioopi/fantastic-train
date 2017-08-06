defmodule Slider.ConsoleOutput do
  @behaviour Slider.Output

  def update(leds) do
    IO.puts(inspect(leds))
  end
end
