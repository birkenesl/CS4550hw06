defmodule Bulls.User do

@derive Jason.Encoder
  defstruct guesses: [],
   bullreports: [],
   cowreports: [],
   wins: 0,
   losses: 0,
   type: "Player",
   badFlag: false


end
