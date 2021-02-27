// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix";

let socket = new Socket(
  "/socket",
   {params: {token: ""}}
 );

// Finally, connect to the socket:
socket.connect();

// Now that you are connected, you can join channels with a topic:
let channel = null//socket.channel("game:SETUPCHANNEL", {});


let state = {
  name: "",
  users: [],
  winFlag: false,
  inProgress: false
};

let callback = null;

// Much of this socket code/design can be attributed
// to Professor Nat Tuck's Lecture 7
function state_update(st) {
  console.log("New State", st);
  state = st;
  if (callback) {
    callback(st);
  }
}

export function ch_set(gameName) {
  channel = socket.channel("game:" + gameName, {});
  channel.join()
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to join", resp)
    });
  channel.on("view", state_update);
  channel.on("leave", state_update);

}

export function ch_join(cb) {
  callback = cb;
  callback(state);

}

export function ch_push(guess) {
  channel.push("guess", guess)
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to push", resp)
         });
}

export function ch_reset() {
  channel.push("reset", {})
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to reset", resp)
        });
}

export function ch_login(name) {
  channel.push("login", {name: name})
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to push", resp)
         });
}

export function ch_ready(typePlayer) {
  channel.push("ready", typePlayer)
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to ready up", resp)
         });
}

export function ch_leave() {
  channel.push("leave", {})
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to reset", resp)
        }
         )
         .leave();
  //let stateClean = {
    //name: "",
    //users: [],
    //winFlag: false,
    //inProgress: false
  //};
  //state_update(stateClean)
}




export default socket
