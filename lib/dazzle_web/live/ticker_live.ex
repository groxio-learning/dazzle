defmodule DazzleWeb.TickerLive do
  use DazzleWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 20)}
  end
  
  def render(assigns) do
    ~L"""
    <div phx-window-keydown="keydown">
      <br><br><br><br>
      <div>
        <%= arrow_link(:decrement) %>
        <button><%= @count %></button>
        <%= arrow_link(:increment) %>
      </div>

      <br><br><br><br>

      <pre style="transform: rotate(<%= @count %>deg);
                             text-align: center; 
                             width: 400px;">
        <h2>Rotated</h2>
      </pre>
      <br><br><br><br>
      <pre>
      <h2 style="text-align: center;"><%= scrolled("scrolled", @count) %></h2>
      </pre>
    </div>
    """
  end
  
  defp arrow_link(direction) do
    """
    <span phx-click="change" phx-value-direction="#{direction}">&##{unicode(direction)};</span>
    """
    |> Phoenix.HTML.raw
  end

  defp unicode(:decrement), do: 9664
  defp unicode(:increment), do: 9658
  
  defp scrolled(string, count) do
    split_point = rem(count, 40)
    message = padded_message(string)
      
    Enum.drop(message, split_point) 
    |> Kernel.++(Enum.take(message, split_point))
    |> to_string
    |> Phoenix.HTML.raw
  end
  
  defp padded_message(string) do
    sixty_spaces = List.duplicate(32, 40)

    string
    |> String.to_charlist
    |> Kernel.++(sixty_spaces)
    |> Enum.take(60)
  end
  
  defp inc(socket) do
    assign(socket, count: wrap(socket.assigns.count + 1))
  end
  
  defp dec(socket) do
    assign(socket, count: wrap(socket.assigns.count - 1))
  end
  
  defp wrap(number), do:  rem(number, 360)
  
  def handle_event("change", %{"direction" => "increment"}, socket) do
    {:noreply, inc(socket)}
  end
  
  def handle_event("change", %{"direction" => "decrement"}, socket) do
    {:noreply, dec(socket)}
  end
  
  def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
    {:noreply, inc(socket)}
  end
  
  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply, dec(socket)}
  end
  
  def handle_event("keydown", _, socket) do
    {:noreply, socket}
  end

  
  def handle_info(:tick, socket) do
    {:noreply, inc(socket)}
  end
end
