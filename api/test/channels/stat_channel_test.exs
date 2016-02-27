defmodule App.StatChannelTest do
  use App.ChannelCase

  alias App.StatChannel

  setup do
    {:ok, _, socket} =
      socket
      |> subscribe_and_join(StatChannel, "stats:global")

    {:ok, socket: socket}
  end

  test "fetch replies with current stats", %{socket: socket} do
    ref = push socket, "fetch"
    assert_reply ref, :ok, %{total: _, leagues: _, new: _, updates: _}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
