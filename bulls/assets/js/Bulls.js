import React, { useState, useEffect } from 'react';
import 'milligram';

import {ch_join, ch_push, ch_reset, ch_login, ch_set, ch_ready} from './socket';



function Setup({state}) {
  let {name, users, winFlag, inProgress} = state;

  let typePlayer = true;

  var players = [];

  for (const user in users) {

    players.push
    (<p> {users[user].type} {users[user].name} is {users[user].ready} </p>);
  }

  function readyUp() {

      ch_ready(typePlayer);

  }

  function toggleType() {
    typePlayer = !typePlayer;
  }
  //<button onClick={leave}>Leave</button>
  return (
    <div>
      <h1> Lobby </h1>

      <p> {players} </p>


      <input type="checkbox" onClick={toggleType} />


      <button onClick={readyUp}>Ready Up</button>






    </div>



  )


}


function Play({state}) {

  let {name, users, winFlag, inProgress} = state;


  function check(obj) {
    console.log(obj.name);
    return obj.name === name;
  }
  let thisUser = users.find(check)

  // this usestate hook is being used for input.
  const [text, setText] = useState("");



  //console.log(thisUser.guesses);
  // not all of this will be used
  let guesses = thisUser.guesses;
  let bullreports = thisUser.bullreports;
  let cowreports = thisUser.cowreports;
  let wins = thisUser.wins;
  let losses = thisUser.losses;
  let type = thisUser.type;
  let badFlag = thisUser.badFlag;


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

    for (i = 0; i < users[j].guesses.length; i++) {
      guessRows.push(<p> name: {users[j].name} Guess: {users[j].guesses[i]}
      Bulls: {users[j].bullreports[i]} Cows: {users[j].cowreports[i]} </p>)
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
    users: [],
    winFlag: false,
    inProgress: false,
  });






  useEffect(() => {
      ch_join(setState);

  })

  let body = null;


  // temp logic
  if (state.name === "") {
    body = <Login />
  }
  else if (!state.inProgress) {
    body = <Setup state={state}/>
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
