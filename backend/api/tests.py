from django.test import TestCase

import json
from channels.generic.websocket import AsyncWebsocketConsumer

class TelemetryConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.device_id = self.scope['url_route']['kwargs']['device_id']
        self.group_name = f"device_{self.device_id}"
        
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data):
        data = json.loads(text_data)

        # broadcast aux Flutter clients connectés sur ce device
        await self.channel_layer.group_send(
            self.group_name,
            {
                "type": "telemetry_message",
                "data": data
            }
        )

    async def telemetry_message(self, event):
        await self.send(text_data=json.dumps(event["data"]))
