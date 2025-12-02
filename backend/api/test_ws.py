import websocket
import json

def on_message(ws, message):
    print("Received:", message)

def on_open(ws):
    print("Connected!")
    ws.send(json.dumps({"test": "hello"}))

ws = websocket.WebSocketApp(
    "ws://127.0.0.1:8000/ws/telemetry/5/",  # <-- ton chemin exact
    on_open=on_open,
    on_message=on_message
)

ws.run_forever()
