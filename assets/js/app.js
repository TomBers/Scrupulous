import "../css/app.scss"

import "phoenix_html"

import cytoscape from 'cytoscape'
import fcose from 'cytoscape-fcose';

window.cytoscape = cytoscape
window.layoutFunc = fcose;

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

const COLOUR_MODE_COOKIE_NAME = "colourMode"


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

function addEvent(ele) {
    ele.addEventListener('click', () => {
       // Get the target from the "data-target" attribute
       const target = ele.dataset.target;
       const $target = document.getElementById(target);

       // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
       ele.classList.toggle('is-active');
       $target.classList.toggle('is-active');
  });
}

document.addEventListener('DOMContentLoaded', () => {

    getCookie(COLOUR_MODE_COOKIE_NAME) == "black" ? toggleColorMode() : null;

    var nav = document.getElementById("navBurger");
    var dropdown = document.getElementById("settings-nav-bar");

    addEvent(nav);
    if(dropdown) {
        addEvent(dropdown);
    }

  document.getElementById("night-mode-button").addEventListener('click', () => {
    toggleColorMode();
  })

});