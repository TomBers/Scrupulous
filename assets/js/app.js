import "../css/app.scss"

import "phoenix_html"

import cytoscape from 'cytoscape'
import fcose from 'cytoscape-fcose';

window.cytoscape = cytoscape
window.layoutFunc = fcose;

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

const COLOUR_MODE_COOKIE_NAME = "colour_mode"


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect()

//let socket = new Socket("/socket", {params: {token: window.userToken}})

//socket.connect()

function toggleColorMode() {
    var body = document.getElementsByTagName("BODY")[0];
    body.classList.toggle("night-mode");
    var html = document.getElementsByTagName("html")[0];
    var colour;
    html.style.backgroundColor != "black" ? colour = "black" : colour = "white";
    html.style.backgroundColor = colour;
    document.cookie = COLOUR_MODE_COOKIE_NAME + "=" + colour + ";path=/";
}

function getCookie(cname) {
    let cookieValue = document.cookie.split('; ').find(row => row.startsWith(cname));
    return cookieValue ? cookieValue.split('=')[1] :  "";
}


document.addEventListener('DOMContentLoaded', () => {

    getCookie(COLOUR_MODE_COOKIE_NAME) == "black" ? toggleColorMode() : null;

    var nav = document.getElementById("navBurger")
    nav.addEventListener('click', () => {
       // Get the target from the "data-target" attribute
       const target = nav.dataset.target;
       const $target = document.getElementById(target);

       // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
       nav.classList.toggle('is-active');
       $target.classList.toggle('is-active');
  });


  document.getElementById("night-mode-button").addEventListener('click', () => {
    toggleColorMode();
  })

});