defmodule Bulls.Game do
  # this module should compute things

  def new do
    %{
      secret: randomFourDigit([]),
      guesses: [],
      badFlag: false,
      winFlag: false,
      bullreports: [],
      cowreports: [],
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

  def guess(st, number) do
    if isNum?(number) && validateGuess(st, number) do
      number = String.to_integer(number)
      bullsAndCows = reportBullsAndCows(st, number)
      bulls = elem(bullsAndCows, 0)
      cows = elem(bullsAndCows, 1)
      if number === st.secret do
        %{ st | guesses: st.guesses ++ [Enum.join(split_integer(number))], winFlag: true,
         badFlag: false, bullreports: st.bullreports ++ [bulls],
         cowreports: st.cowreports ++ [cows]}
      else
        %{ st | guesses: st.guesses ++ [Enum.join(split_integer(number))], badFlag: false,
         bullreports: st.bullreports ++ [bulls],
         cowreports: st.cowreports ++ [cows]}
      end
    else
      %{ st | badFlag: true}
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
    st.winFlag == false && length(st.guesses) < 8 && MapSet.size(numSet) == 4
    && Enum.all?(numSet, fn x -> is_integer(x) end)
  end

  # basically strips the secret from the state,
  # so we can return this to the browser
  def view(st, name) do
    %{
      name: name,
      guesses: st.guesses,
      badFlag: st.badFlag,
      winFlag: st.winFlag,
      bullreports: st.bullreports,
      cowreports: st.cowreports,

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
