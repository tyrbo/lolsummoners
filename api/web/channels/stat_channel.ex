defmodule App.StatChannel do
  use App.Web, :channel

  def join("stats:global", payload, socket) do
    {:ok, socket}
  end

  def handle_in("fetch", _payload, socket) do
    stats = %{total: 0, leagues: 0, new: 0, updates: 0}
    {:reply, {:ok, stats}, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
