defmodule DazzleWeb.TickerLive do
  use DazzleWeb, :live_view

  def mount(_params, _session, socket) do
    :timer.send_interval(250, self(), :tick)
    {:ok, assign(socket, count: 20)}
  end
  
  def render(assigns) do
    ~L"""
    <br><br><br><br><br><br><br><br><br>
    <h1>Dazzle count: <%= @count %></h1>

    <br><br><br><br><br><br><br><br><br>

    <pre style="transform: rotate(<%= @count %>deg);
                           text-align: center;">
      <h2>Rotated</h2>
    </pre>
    <br><br><br><br><br><br><br><br><br>
    <pre>
    <h2 style="text-align: center;"><%= scrolled("scrolled", @count) %></h2>
    </pre>
    """
  end
  
  defp scrolled(string, count) do
    split_point = rem(count, 40)
    message = padded_message(string, count)
      
    Enum.drop(message, split_point) 
    |> Kernel.++(Enum.take(message, split_point))
    |> to_string
    |> Phoenix.HTML.raw
  end
  
  defp padded_message(string, count) do
    sixty_spaces = List.duplicate(32, 40)

    string
    |> String.to_charlist
    |> Kernel.++(sixty_spaces)
    |> Enum.take(60)
  end
  
  defp inc(socket) do
    assign(socket, count: socket.assigns.count + 1)
  end
  
  def handle_info(:tick, socket) do
    {:noreply, inc(socket)}
  end
end
