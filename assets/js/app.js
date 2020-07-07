import "../css/app.scss"

import "phoenix_html"

import cytoscape from 'cytoscape'
import fcose from 'cytoscape-fcose';

window.cytoscape = cytoscape
window.layoutFunc = fcose;



//import {Socket} from "phoenix"
//import LiveSocket from "phoenix_live_view"


//let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
//let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks});
//liveSocket.connect()
//
//let socket = new Socket("/socket", {params: {token: window.userToken}})
//
//socket.connect()




