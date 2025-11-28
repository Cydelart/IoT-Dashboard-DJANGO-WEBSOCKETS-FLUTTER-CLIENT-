from channels.generic.websocket import AsyncWebsocketConsumer
import json

#controler la communication websocket 
#quand flutter se connecte django channels envoie les cnx ici
class TelemetryConsumer(AsyncWebsocketConsumer):
    #fct auto quand flutter ouvre cnx websocket
    async def connect(self):
        #recuperer l id de l url de websocket
        self.device_id = self.scope["url_route"]["kwargs"]["device_id"]
        #creation d un nom de groupe
        self.group_name = f"device_{self.device_id}"
        #ajouter client flutter dans le grp
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    # Lien direct avec  code perform_create dans views.py
    async def send_telemetry(self, event):
        data = event["data"]
        await self.send(text_data=json.dumps(data)) #transformer les donnes en json et envois dans la cnx websocket