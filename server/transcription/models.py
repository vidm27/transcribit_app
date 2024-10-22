from django.db import models

class Transcription(models.Model):
    id = models.UUIDField(primary_key=True)
    path_file = models.FileField()
    token_url = models.CharField(max_length=255)
    uploaded = models.DateTimeField(auto_now_add=True)
    duration = models.TimeField()
    language = models.CharField(max_length=25)
    language_probability = models.FloatField()
    topic = models.CharField(max_length=25)
    tag = models.CharField(max_length=25)

    def __str__(self):
        return (f"Transcripción en {self.language} (probabilidad: {self.language_probability:.2f}), "
                f"duración: {self.duration:.2f} segundos")

class Segment(models.Model):
    id = models.UUIDField(primary_key=True)
    transcription_id = models.ForeignKey(Transcription, on_delete=models.CASCADE, related_name='segments')  # Aquí añades related_name
    minutes_start = models.FloatField()
    minutes_end = models.FloatField()
    segment_edit = models.CharField(max_length=255)
    segment_original = models.CharField(max_length=255)
    uploaded = models.DateTimeField(auto_now_add=True)
    edited = models.DateTimeField(auto_now=True)

# Create your models here.
# table transcription {
#   id uuid [pk]
#   root_folder str
#   child_folder str
#   collection_id uuid
#   path_file str
#   token_url str
#   statu_id int
#   uploaded datetime
#   duration time
#   languaje str
#   topic str
#   tag str
# }
#
# table segment{
#   id uuid [pk]
#   transcription_id uuid
#   minutes_start float
#   minutes_end float
#   segment_edit str
#   segment_original str
#   uploaded datetime
#   edited datetime
# }