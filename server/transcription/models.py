import secrets
import uuid

from django.db import models


def generate_token():
    return secrets.token_urlsafe(32)[:32]  # Return only the first 32 characters.


class Transcription(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    path_file = models.FileField(null=True)
    title = models.CharField(max_length=255, null=True)
    token_url = models.CharField(max_length=255, unique=True, editable=False, default=generate_token)
    uploaded = models.DateTimeField(auto_now_add=True)
    duration = models.TimeField(null=True)
    language = models.CharField(max_length=25, null=True)
    language_probability = models.FloatField(null=True)
    topic = models.CharField(max_length=25, null=True)
    tag = models.CharField(max_length=25, null=True)
    state = models.ForeignKey('State', on_delete=models.SET_NULL, null=True)

    def save(self, *args, **kwargs):
        try:
            if not self.state:
                self.state = State.objects.get(id=1)  # Aquí aseguras que el estado predeterminado sea el id 1
            super().save(*args, **kwargs)
            print(f"Transcripción guardada: {self}")
        except Exception as e:
            print(f"Error al guardar la transcripción: {e}")
            raise

    def __str__(self):
        return (
            f"Transcripción en {self.language is not None and self.language or 'Desconocido'} (probabilidad: {self.language_probability is not None and self.language_probability or 'Desconocido'}), "
            f"duración: {self.duration is not None and self.duration or 'Desconocido'} segundos")


class Segment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    transcription = models.ForeignKey(Transcription, on_delete=models.CASCADE,
                                      related_name='segments')  # Aquí añades related_name
    minutes_start = models.FloatField()
    minutes_end = models.FloatField()
    segment_edit = models.CharField(max_length=255, null=True)
    segment_original = models.CharField(max_length=255)
    uploaded = models.DateTimeField(auto_now_add=True)
    edited = models.DateTimeField(auto_now=True)


class State(models.Model):
    id = models.IntegerField(primary_key=True, editable=False)
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name
