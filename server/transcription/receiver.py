
from django.db.models.signals import post_save
from django.dispatch import receiver
from faster_whisper import WhisperModel
from loguru import logger

from transcription.audio_transcription.model.transcription_model import SegmentModel, TranscriptionModel
from transcription.models import Transcription, Segment


def initialize_model(model_size: str = "medium") -> WhisperModel:
    logger.info(f"Initializing model {model_size}...")
    model: WhisperModel = WhisperModel(model_size, device="cpu", compute_type="int8")
    return model

def float_to_timefield(duration_float):
    hours = int(duration_float // 60)
    minutes = int(duration_float % 60)
    seconds = int((duration_float % 1) * 60)
    return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

@receiver(post_save, sender=Transcription)
def transcribe_audio(sender, instance, created, **kwargs) -> None:
    if created:
        logger.info("Transcribing audio...")
        logger.info(f"Sender: {sender}, Instance: {instance}")
        model = initialize_model()
        current_segments, info = model.transcribe(instance.path_file, beam_size=5)
        logger.info(f"Segments: {current_segments}")
        segments_format = []
        for segment in current_segments:
            logger.info(f"Segment: {segment}")
            segments_format.append(SegmentModel(start=segment.start, end=segment.end, text=segment.text))
        try:
            transcription = TranscriptionModel(
                language=info.language,
                language_probability=info.language_probability,
                duration=info.duration,
                segments=segments_format
            )
            instance.language = transcription.language
            instance.language_probability = transcription.language_probability
            instance.duration = float_to_timefield(transcription.duration)
            instance.state = 2
            instance.save()

            logger.info(f"Create {len(segments_format)} segments")
            segments_format = [Segment(transcription_id=instance.id, minutes_start=segment.start, minutes_end=segment.end,
                                       segment_original=segment.text) for segment in transcription.segments]
            Segment.objects.bulk_create(segments_format)
            logger.debug(f"Created {len(segments_format)} segments")
        except Exception as e:
            logger.error(f"Error al crear la transcripción: {e}")
            instance.state = 3
            instance.save()

