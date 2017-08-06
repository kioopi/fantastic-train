defmodule UiWeb.LedsChannel do
  use UiWeb, :channel
  require Logger

  def join("leds:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (leds:lobby).
  def handle_in("leds", payload, socket) do
    Logger.info("Received #{inspect payload}")
    Ui.update(payload)
    broadcast(socket, "leds", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
