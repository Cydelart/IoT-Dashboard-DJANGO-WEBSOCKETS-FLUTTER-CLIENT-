import json
from channels.generic.websocket import AsyncWebsocketConsumer
from .influx import get_history  # ton code pour lire InfluxDB

class TelemetryConsumer(AsyncWebsocketConsumer):
    async def connect(self):
<<<<<<< HEAD
        user = self.scope.get("user")
        # Si pas connecté -> on refuse la connexion
        if user is None or user.is_anonymous:
            await self.close()
            return
        #recuperer l id de l url de websocket
        self.device_id = self.scope["url_route"]["kwargs"]["device_id"]
        #creation d un nom de groupe
        self.group_name = f"device_{self.device_id}"
        #ajouter client flutter dans le grp
        await self.channel_layer.group_add(self.group_name, self.channel_name)
=======
        self.device_id = self.scope['url_route']['kwargs']['device_id']
>>>>>>> b8df76b (final version)
        await self.accept()

        # Envoi des dernières données à la connexion
        history = get_history(int(self.device_id))
        print(history)  # <-- Ajoute ça pour voir si tu récupères quelque chose
        for h in history:
            await self.send(text_data=json.dumps(h))

    async def disconnect(self, close_code):
        pass

    # Ici tu pourrais gérer les messages venant de Flutter si besoin
    async def receive(self, text_data):
        pass
