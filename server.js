const express = require('express');
const bodyParser = require('body-parser');
const ws = require('ws');
const ws_port = 8080;
const api_port = 8081;
const path = '/ws/';
const app = express();

app.use(bodyParser.json());

const wss = new ws.Server({ port: ws_port, path: path });

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
        client.send(JSON.stringify(msg));
     });
 };

let sendMessage = (message) => {
    wss.clients.forEach(client => {
        client.send(message);
    });
};

app.post('/kubeevents', (req, res) => {
    console.log('hello...')
    console.log(req.body);
    wss.broadcast(req.body);
    res.status(200).send()
});


console.log(`WebSocket Server started on port ${ws_port}`);
 
app.listen(api_port, () => console.log(`k8s event consumer app listening on port ${api_port}!`));
