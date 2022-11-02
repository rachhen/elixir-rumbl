defmodule RumblWeb.UserLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: Rumbl.Accounts.change_user(%Rumbl.Accounts.User{}))}
  end

  def render(assigns) do
    Phoenix.View.render(RumblWeb.UserView, "new.html", assigns)
  end
end
