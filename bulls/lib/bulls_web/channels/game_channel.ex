defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game
  alias Bulls.GameServer

  @impl true
  def join("game:" <> name, payload, socket) do
    if authorized?(payload) do
      GameServer.start(name) # name represents game name
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
    view = socket.assigns[:name]
    |> GameServer.peek()
    |> Game.view(user)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("guess", %{"number" => num}, socket) do
    user = socket.assigns[:user]
    view = socket.assigns[:name]
    |> GameServer.guess(num)
    |> Game.view(user)
    IO.puts "before broadcast"
    broadcast(socket, "view", view)
    IO.puts "after broadcast"

    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("reset", _, socket) do
    user = socket.assigns[:user]
    view = socket.assigns[:name]
    |> GameServer.reset()
    |> Game.view(user)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  #intercept ["view"]

  #@impl true
  #def handle_out("view", msg, socket) do
    #user = socket.assigns[:user]
    #msg = %{msg | name: user}
    #push(socket, "view", msg)
    #{:noreply, socket}
  #end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
