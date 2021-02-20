import React, { useState, useEffect } from 'react';
import 'milligram';

import {ch_join, ch_push, ch_reset } from './socket';




function Bulls() {

  const [state, setState] = useState({
    guesses: [],
    badFlag: false,
    winFlag: false,
    bullreports: [],
    cowreports: [],
  });

  let {guesses, badFlag, winFlag, bullreports, cowreports} = state;


  // this usestate hook is being used for input.
  const [text, setText] = useState("");

  useEffect(() => {
    ch_join(setState);

  })

  let warning = null;
  if (state.badFlag) {
    warning = <p> Input must be four unique digits! </p>;
  }
  else if (state.winFlag) {
    warning = <p> You won! Reset to play again. </p>
  }
  else if (state.guesses.length === 8) {
    warning = <p>You lost! Reset to play again.</p>;
  }

  function reset() {
    ch_reset();
  }

  // this function is attributed to Nat Tuck's lecture 4 class code
  function updateText(ev) {
    let vv = ev.target.value;
    setText(vv);
  }

  function guess() {

    ch_push({number: text})
    setText(""); // clear text state for input

  }

  // this function is attributed to Nat Tuck's lecture 4 class code
  function keyPress(ev) {
    if (ev.key === "Enter") {
      guess();
    }
  }


  return (
    <div className="App">
      <h1>Bulls and Cows</h1>
      <p>
        <input type="text" value={text} onChange={updateText}
                                        onKeyPress={keyPress}/>
        <button onClick={guess}>Guess</button>
        <button onClick={reset}>Reset</button>
      </p>
        {warning}
      <p>Guess 1: {state.guesses[0]}  Bulls: {state.bullreports[0]}
      Cows: {state.cowreports[0]} </p>
      <p>Guess 2: {state.guesses[1]}  Bulls: {state.bullreports[1]}
      Cows: {state.cowreports[1]} </p>
      <p>Guess 3: {state.guesses[2]}  Bulls: {state.bullreports[2]}
      Cows: {state.cowreports[2]} </p>
      <p>Guess 4: {state.guesses[3]}  Bulls: {state.bullreports[3]}
      Cows: {state.cowreports[3]} </p>
      <p>Guess 5: {state.guesses[4]}  Bulls: {state.bullreports[4]}
      Cows: {state.cowreports[4]} </p>
      <p>Guess 6: {state.guesses[5]}  Bulls: {state.bullreports[5]}
      Cows: {state.cowreports[5]} </p>
      <p>Guess 7: {state.guesses[6]}  Bulls: {state.bullreports[6]}
      Cows: {state.cowreports[6]} </p>
      <p>Guess 8: {state.guesses[7]}  Bulls: {state.bullreports[7]}
      Cows: {state.cowreports[7]} </p>

    </div>
  );
}


export default Bulls;
