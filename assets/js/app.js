import { Socket } from "phoenix";
import "phoenix_html";
import LiveSocket from "phoenix_live_view";
import "../css/app.css";

const liveSocket = new LiveSocket("/live", Socket);
liveSocket.connect();
