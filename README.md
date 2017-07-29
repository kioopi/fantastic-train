# Elixir Nerves Raspberry Pi LED Array

[![Video of hardware running the code](http://img.youtube.com/vi/1KTMTBpTV34/0.jpg)](http://www.youtube.com/watch?v=1KTMTBpTV34 "Video")


Very basic Nerves project controlling a number of LEDs with a turning dial.

The LEDs are controlled by two daisy-chained 74HC595 shift registers.
The turning dial is a KY040 rotary encoder.

## Run the code

 * Clone the repo
 * Create a `config/secrets.exs` file and edit it
 * Get and solder and wire the hardware correctly
 * mix deps.get
 * mix firmware
 * mix firmware.burn
 * put sd into rasp
 * enjoy

 * change code
 * mix firmware
 * mix firmware.push `ip of your rasp3` --target rpi3
 * updated over the air!


## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
