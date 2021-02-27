defmodule Bulls.Game do
  # this module should compute things

  #alias Bulls.User

  def new do
    %{
      secret: randomFourDigit([]),
      users: [], # Map of user name => user object.
      # when sent to Bulls.js,
      winFlag: false,
      inProgress: false # the logic for wins needs to be more thought out
    }

  end

  def defaultUser do
    %{name: "",
      guesses: [],
      bullreports: [],
      cowreports: [],
      wins: 0,
      losses: 0,
      type: "Player",
      ready: "not ready",
      badFlag: false}
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
    %{ st | users: [Enum.find(st.users,
      %{defaultUser() | name: user}, fn x -> x.name == user end) | st.users] }
    # add user to game state, if it is not already there

  end

  def ready(st, typePlayer, user) do
    userObj = Enum.find(st.users, defaultUser(), fn x -> x.name == user end)
    str = ""
    if (typePlayer) do
      str = "Player"
    else
      str = "Observer"
    end
    %{ st | users: [%{userObj | type: str, ready: "ready"}
    | Enum.reject(st.users,
    fn x -> x.name == user end)]}
  end

  def guess(st, number, user) do
    IO.inspect(st)
    IO.inspect(st.users)
    userObj = Enum.find(st.users, defaultUser(), fn x -> x.name == user end)
    if isNum?(number) && validateGuess(st, number) do
      number = String.to_integer(number)
      bullsAndCows = reportBullsAndCows(st, number)
      bulls = elem(bullsAndCows, 0)
      cows = elem(bullsAndCows, 1)
      if number === st.secret do
        %{ st | users: [%{userObj | guesses: userObj.guesses
        ++ [Enum.join(split_integer(number))],
       wins: userObj.wins + 1, badFlag: false,
       bullreports: userObj.bullreports ++ [bulls],
       cowreports: userObj.cowreports ++ [cows]} | Enum.reject(st.users,
        fn x -> x.name == user end)], winFlag: true}
      else
        %{ st | users: [%{userObj | guesses: userObj.guesses
        ++ [Enum.join(split_integer(number))], badFlag: false,
       bullreports: userObj.bullreports ++ [bulls],
       cowreports: userObj.cowreports ++ [cows]} | Enum.reject(st.users,
        fn x -> x.name == user end)], winFlag: false}
      end
    else
      %{ st | users: [%{userObj | badFlag: true} | Enum.reject(st.users,
      fn x -> x.name == user end)]}
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
    st.winFlag == false && MapSet.size(numSet) == 4
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
