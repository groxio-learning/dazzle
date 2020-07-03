defmodule DazzleWeb.TickerLive do
  use DazzleWeb, :live_view
  alias DazzleWeb.TickerLive.FormData

  def mount(_params, _session, socket) do
    count = 20
    string = "Dazzle"
    changeset = 
      FormData.new(string, count) 
      |> FormData.change(%{})
      
    {
      :ok, 
      assign(socket, count: count, string: string, changeset: changeset)
    }
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
        <h2><%= @string %></h2>
      </pre>
      <br><br><br><br>
      <pre>
      <h2 style="text-align: center;"><%= scrolled(@string, @count) %></h2>
      </pre>
      
      <%= f = form_for @changeset, "#",
        phx_change: "validate",
        phx_submit: "save", 
        as: :form %>

        <%= label f, :string %>
        <%= text_input f, :string %>
        <%= error_tag f, :string %>

        <%= label f, :count %>
        <%= text_input f, :count %>
        <%= error_tag f, :count %>

        <%= submit "Save" %>
      </form>
      <%= @changeset.valid? %>

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
    count = wrap(socket.assigns.count + 1)
    assign(socket, count: count)
    |> validate(FormData.new(socket.assigns.string, count))
  end
  
  defp dec(socket) do
    count = wrap(socket.assigns.count - 1)
    assign(socket, count: count)
    |> validate(FormData.new(socket.assigns.string, count))
  end
  
  defp wrap(number), do:  rem(number, 360)
  
  defp validate(socket, params) do
    changeset = 
      FormData.new(socket.assigns.string, socket.assigns.count)
      |> FormData.change(params)
    
    assign(socket, changeset: changeset)
  end
  
  defp save(socket, params) do
    changeset = 
      FormData.new(socket.assigns.string, socket.assigns.count)
      |> FormData.change(params)
      
    apply_changes(socket, changeset.changes, changeset.valid?)
  end
  
  defp apply_changes(socket, changes, true) do
    assign(socket, Map.to_list(changes))
  end
  defp apply_changes(socket, _changes, _valid), do: socket
  
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
  
  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, validate(socket, params)}
  end

  def handle_event("save", %{"form" => params}, socket) do
    {:noreply, save(socket, params)}
  end

  
  def handle_info(:tick, socket) do
    {:noreply, inc(socket)}
  end
end
