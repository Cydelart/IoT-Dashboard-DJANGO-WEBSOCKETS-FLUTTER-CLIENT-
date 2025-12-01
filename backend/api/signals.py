from django.db.models.signals import post_save
from django.dispatch import receiver
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from .models import Telemetry
from .serializers import TelemetrySerializer


@receiver(post_save, sender=Telemetry)
def telemetry_created(sender, instance, created, **kwargs):
    if not created:
        return

    channel_layer = get_channel_layer()
    group_name = f"device_{instance.device.id}"

    data = TelemetrySerializer(instance).data

    async_to_sync(channel_layer.group_send)(  # des qu une telemetry est enregistrer il envoie a tous les flutter cnt au grp
        group_name,
        {
            "type": "send.telemetry",  # <- cela appellera send_telemetry dans Consumer
            "data": data,
        }
    )