defmodule Ui do
  @moduledoc """
  Ui keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use GenServer

  require Logger


  # Client API

  def child_spec(output_module) do
    Supervisor.Spec.worker(__MODULE__, [%{output_module: output_module}])
  end

  def start_link(%{ output_module: output_module }) do
    GenServer.start_link(__MODULE__, output_module, name: __MODULE__)
  end

  def update(%{ "leds" => leds }) do
    GenServer.call(__MODULE__, {:update, leds })
  end

  def init(state) do
    Logger.debug("Init Ui Server #{inspect state}")
    {:ok, state }
  end

  def handle_call({:update, leds}, _from, %{ output_module: output_module }) do
    parsed = parse_payload(leds)
    Logger.info("As array #{parsed} -> #{inspect output_module}")
    output_module.set(parsed)
    {:reply, :ok, output_module}
  end

  defp parse_payload(leds) do
    String.graphemes(leds)
     |> Enum.map(&parse_char/1)
     |> Enum.filter(&(&1))
  end

  defp parse_char("0"), do: 0
  defp parse_char("1"), do: 1
  defp parse_char("o"), do: 0
  defp parse_char("x"), do: 1
  defp parse_char(_), do: nil
end
