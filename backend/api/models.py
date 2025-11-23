from django.db import models

class Device(models.Model):
    STATUS_CHOICES = [
        ("online", "Online"),
        ("offline", "Offline"),
        ("error", "Error"),
    ]

    name = models.CharField(max_length=100)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="offline")

    def __str__(self):
        return f"{self.name} ({self.status})"

