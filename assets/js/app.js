import "../css/app.scss"

import "phoenix_html"

import cytoscape from 'cytoscape'
import fcose from 'cytoscape-fcose';

window.cytoscape = cytoscape
window.layoutFunc = fcose;



import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect()

//let socket = new Socket("/socket", {params: {token: window.userToken}})

//socket.connect()

document.addEventListener('DOMContentLoaded', () => {
    var nav = document.getElementById("navBurger")
    nav.addEventListener('click', () => {
       // Get the target from the "data-target" attribute
       const target = nav.dataset.target;
       const $target = document.getElementById(target);

       // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
       nav.classList.toggle('is-active');
       $target.classList.toggle('is-active');
  });

  var nightMode = document.getElementById("night-mode-button");
  nightMode.addEventListener('click', () => {
    var body = document.getElementsByTagName("BODY")[0];
    console.log(body);
    body.classList.toggle("night-mode");
  })

});