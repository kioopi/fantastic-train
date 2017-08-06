defmodule Rotary.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [app: :rotary,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application, do: application(@target)

  def application("host") do
    [
      mod: {
        Rotary.Application, [
          input_mod: Rotary.InputMock,
          callback_mod: Rotary.CallbackMock,
          data_pin: 1,
          clock_pin: 2
        ]
      },
      extra_applications: [:logger]
    ]
  end

  def application(_target) do
    datapin = Application.get_env(:rotary, :datapin)
    clockpin = Application.get_env(:rotary, :clockpin)
    [
      mod: {
        Rotary.Application, [
          input_mod: Gpio,
          callback_mod: Slider.Server,
          data_pin: datapin,
          clock_pin: clockpin
        ]
      },
      extra_applications: [:logger]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:my_app, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [] ++ deps(@target)
  end

  def deps("host"), do: []
  def deps(_target) do
    [ {:elixir_ale, "~> 0.5.7"} ]
  end
end
