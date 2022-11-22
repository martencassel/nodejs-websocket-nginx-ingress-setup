const ws = require('ws');
const port = 8080;
const path = '/ws/';

const wss = new ws.Server({ port: port, path: path });

ws.onopen = function () {
    var t = setInterval(function(){
        if (ws.readyState != 1) {
            clearInterval(t);
            return;
        }
        ws.send('{type:"ping"}');
    }, 55000);
};

wss.on("connection", ws => {
    console.log('on connection');
    ws.on("message", message => {
        console.log('on message');
        console.log(`Received message => ${message}`)
                // Sleep 10 seconds 
        wss.broadcast("ping from server");
    });
    ws.on("close", () => {
        console.log("Client disconnected");
    });
    ws.onerror = (err) => {
        console.log(err);
    }
});

wss.broadcast = function broadcast(msg) {
    console.log(msg);
    wss.clients.forEach(function each(client) {
        client.send(msg);
     });
 };

let sendMessage = (message) => {
    wss.clients.forEach(client => {
        client.send(message);
    });
};


console.log('WebSocket Server started on port 8080');
 
