defmodule Bulls.GameServer do
  use GenServer

  def reg(name) do
    {:via, Registry, {Bulls.GameReg, name}}
  end

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker,
    }
    Bulls.GameSup.start_child(spec)
  end

  def start_link(name) do
    #game = Bulls.BackupAgent.get(name) ||
    game = Bulls.Game.new()
    GenServer.start_link(__MODULE__, game, name: reg(name))
  end

  def guess(name, number, user) do
    GenServer.call(reg(name), {:guess, name, number, user})
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  def adduser(name, user) do
    GenServer.call(reg(name), {:adduser, user})
  end

  def reset(name) do
    GenServer.call(reg(name), {:reset, name})
  end

  def ready(name, typePlayer, user) do
    GenServer.call(reg(name), {:ready, typePlayer, user})
  end

  def init(game) do
    {:ok, game}
  end

  def handle_call({:reset, name}, _from, game) do
    game = Bulls.Game.new
    #Bulls.BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:guess, name, number, user}, _from, game) do
    game = Bulls.Game.guess(game, number, user)
    #Bulls.BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:ready, typePlayer, user}, _from, game) do
    game = Bulls.Game.ready(game, typePlayer, user)
    #Bulls.BackupAgent.put(name, game)
    {:reply, game, game}
  end

  def handle_call({:peek, _name}, _from, game) do
    {:reply, game, game}
  end

  def handle_call({:adduser, user}, _from, game) do
    game = Bulls.Game.addUser(game, user)

    #Bulls.BackupAgent.put(name, game)
    {:reply, game, game}
  end
end
