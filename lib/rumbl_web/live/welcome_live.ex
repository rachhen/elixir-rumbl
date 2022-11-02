defmodule RumblWeb.WelcomeLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
      <div>
        <h1><%= @salutation %></h1>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    salutation = "Welcome to LiveView, from the Programming Phoenix team!"
    {:ok, assign(socket, :salutation, salutation)}
  end
end
