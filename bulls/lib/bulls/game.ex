defmodule Bulls.Game do
  # this module should compute things

  alias Bulls.User

  def new do
    %{
      secret: randomFourDigit([]),
      users: %{"test": %User{}}, # Map of user name => user object.
      # when sent to Bulls.js,
      winFlag: false # the logic for wins needs to be more thought out
    }

  end



  def repHelper(secretList, numList, bulls, cows, index) do

    cond do
      index == 4 ->
        {bulls, cows}
      true ->
        currentNum = Enum.at(numList, index)
        currentSec = Enum.at(secretList, index)
        cond do
          currentNum === currentSec ->
            repHelper(secretList, numList, bulls + 1, cows, index + 1)
          Enum.member?(secretList, currentNum) ->
            repHelper(secretList, numList, bulls, cows + 1, index + 1)
          true ->
            repHelper(secretList, numList, bulls, cows, index + 1)
        end
    end

  end

  def reportBullsAndCows(st, number) do

    splitSecret = split_integer(st.secret)
    splitNum = split_integer(number)
    repHelper(splitSecret, splitNum, 0, 0, 0)

  end

  # this quick utility function attributed to:
  # https://www.toptechskills.com/elixir-phoenix-tutorials-courses
  # /how-to-split-an-integer-into-its-parts-elixir-tutorial-examples/
  # written by Percy Grunwald
  def split_integer(int) do
  int
  |> Kernel.to_string()
  |> String.split("", trim: true)
  |> Enum.map(fn int_string ->
    Integer.parse(int_string)
    |> case do
      {int, _} ->
        int

      _ ->
        0
      end
    end)
  end

  def addUser(st, user) do
    %{ st | users: Map.put_new(st.users, user, %User{})}
    # add user to game state,
    # update users in state, by adding a new key:value



  end

  def guess(st, number, user) do
    IO.inspect(st)
    IO.inspect(st.users)
    if isNum?(number) && validateGuess(st, number) do
      number = String.to_integer(number)
      bullsAndCows = reportBullsAndCows(st, number)
      bulls = elem(bullsAndCows, 0)
      cows = elem(bullsAndCows, 1)
      if number === st.secret do
        %{ st | users: Map.replace!(st.users, user, %{user
        | guesses: Map.get(st.users, user).guesses ++ [Enum.join(split_integer(number))],
         wins: Map.get(st.users, user).wins + 1,
         badFlag: false, bullreports: Map.get(st.users, user).bullreports ++ [bulls],
         cowreports: Map.get(st.users, user).cowreports ++ [cows]}), winFlag: true}
      else
        %{ st | users: Map.replace!(st.users, user, %{user
        | guesses: Map.get(st.users, user).guesses ++ [Enum.join(split_integer(number))],
         badFlag: false, bullreports: Map.get(st.users, user).bullreports ++ [bulls],
         cowreports: Map.get(st.users, user).cowreports ++ [cows]})}
      end
    else
      %{ st | users: Map.replace!(st.users, user, %{user | badFlag: true})}
    end

  end



  def isNum?(number) do
    try do
      x = String.to_integer(number)
      true
    rescue
      ArgumentError -> false
    end
  end

  def validateGuess(st, number) do
    numSet = MapSet.new(split_integer(number))
    st.winFlag == false < 8 && MapSet.size(numSet) == 4
    && Enum.all?(numSet, fn x -> is_integer(x) end)
  end

  # basically strips the secret from the state,
  # so we can return this to the browser
  def view(st, name) do
    #userMap = Enum.each(st.users, fn {k, v} -> {k, Map.from_struct(v)} end)

    %{
      name: name,
      users: st.users,
      winFlag: st.winFlag
    }

  end

  def randomFourDigit(soFar) do
    rand = :rand.uniform(9)
    cond do
      length(soFar) === 4 ->
        soFar
        |> Enum.join()
        |> String.to_integer()
      Enum.member?(soFar, rand) ->
        randomFourDigit(soFar)
      !Enum.member?(soFar, rand) ->
        randomFourDigit([rand | soFar])
    end


  end



end
