defmodule RumblWeb.CounterLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <div>
        <h1>The count is: <%= @val %> </h1>
        <button phx-click="boom" class="alert-danger">BOOM</button>
        <button phx-click="dec">-</button>
        <button phx-click="inc">+</button>
      </div>
      <form phx-change="suggest" phx-submit="search">
        <input type="text" name="q" value="<%= @query %>" list="matches" placeholder="Search..."
          <%= if @loading, do: "readonly" %> />
        <datalist id="matches">
          <%= for match <- @matches do %>
            <option value="<%= match %>"><%= match %></option>
          <% end %>
        </datalist>
        <%= if @result do %>
          <pre><% @result %></pre>
        <% end %>
      </form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       val: 0,
       query: "",
       result: "Searching...",
       loading: false,
       matches: []
     )}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("suggest", %{"q" => query}, socket)
      when byte_size(query) <= 100 do
    {words, _} = System.cmd("grep", ["^#{query}.*", "-m", "5", "/usr/share/dict/words"])
    {:noreply, assign(socket, matches: String.split(words, "\n"))}
  end

  def handle_event("search", %{"q" => query}, socket)
      when byte_size(query) <= 100 do
    send(self(), {:search, query})
    {:noreply, assign(socket, query: query, result: "Searching...", loading: true, matches: [])}
  end
end
