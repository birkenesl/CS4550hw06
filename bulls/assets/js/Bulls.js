import React, { useState, useEffect } from 'react';
import 'milligram';

import {ch_join, ch_push, ch_reset, ch_login, ch_set } from './socket';

function Play({state}) {

  let {name, users, winFlag} = state;

  // this usestate hook is being used for input.
  const [text, setText] = useState("");

  console.log(users[name].guesses);
  // not all of this will be used
  let guesses = users[name].guesses;
  let bullreports = users[name].bullreports;
  let cowreports = users[name].cowreports;
  let wins = users[name].wins;
  let losses = users[name].losses;
  let type = users[name].type;
  let badFlag = users[name].badFlag;


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

  let warning = null;

  if (badFlag) {
    warning = <p> Input must be four unique digits! </p>;
  }

  var guessRows = [];
  var i;
  var j;
  for (j = 0; j < users.length; j++) {
    let user = users[j];
    for (i = 0; i < user.guesses.length; i++) {
      guessRows.push(<p> name: {user} Guess: {user.guesses[i]}
      Bulls: {user.bullreports[i]} Cows: {user.cowreports[i]} </p>)
    }

  }

  return (
    <div className="App">
      <h1>Bulls and Cows</h1>
      <p>
        <p> name: {name} </p>
        <input type="text" value={text} onChange={updateText}
                                        onKeyPress={keyPress}/>
        <button onClick={guess}>Guess</button>
        <button onClick={reset}>Reset</button>

      </p>

        {warning}
        {guessRows}

    </div>
  );
}

function reset() {
  ch_reset();
}

function WonGame({reset}) {
  return (
    <div>
      <h2> You won! Press the button to restart</h2>
      <button onClick={reset}>Reset</button>
    </div>
  );
}

function LostGame({reset}) {
  return (
    <div>
      <h2> You lost. Press the button to restart</h2>
      <button onClick={reset}>Reset</button>
    </div>
  );
}


function Login() {
  const [name, setName] = useState("");
  const [gameID, setGameID] = useState("");


  function setup() {
    ch_set(gameID);
    ch_login(name);

  }

  return (
    <div className="row">
      <div className="column">
        <input type="text"
               value={name}
               onChange={(ev) => setName(ev.target.value)} />
        <input type="text"
               value={gameID}
               onChange={(ev) => setGameID(ev.target.value)} />
      </div>
      <div className="column">
        <button onClick={setup}>Join</button>
      </div>
    </div>
  );
}





function Bulls() {

  const [state, setState] = useState({
    name: "",
    users: {},
    winFlag: false
  });






  useEffect(() => {
      ch_join(setState);

  })

  let body = null;


  // temp logic
  if (state.name === "") {
    body = <Login />
  }
  else if (state.winFlag){
    body = <WonGame reset={reset}/>;
  }
  else  {
    body = <Play state={state} />;
  }



  //else {
    //body = <LostGame reset={reset}/>;
  //}

  return (
    <div className="container">

          {body}

    </div>

  )


}


export default Bulls;
