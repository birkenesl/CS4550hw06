defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game
  alias Bulls.GameServer

  @impl true
  def join("game:" <> name, payload, socket) do
    if authorized?(payload) do
      GameServer.start(name)
      view = GameServer.peek(name)
      |> Game.view("")
      socket = assign(socket, :name, name)
      {:ok, view, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("login", %{"name" => user}, socket) do
    socket = assign(socket, :user, user)
    name = socket.assigns[:name]
    view = GameServer.adduser(name, user)
    |> Game.view(user)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("guess", %{"number" => num}, socket) do
    user = socket.assigns[:user]
    name = socket.assigns[:name]
    view = GameServer.guess(name, num, user)
    |> Game.view(user)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("reset", _, socket) do
    user = socket.assigns[:user]
    name = socket.assigns[:name]
    view = GameServer.reset(name)
    |> Game.view(user)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end


  intercept ["view"]

  @impl true
  def handle_out("view", msg, socket) do
    user = socket.assigns[:user]
    msg = %{msg | name: user}
    push(socket, "view", msg)
    {:noreply, socket}
  end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
