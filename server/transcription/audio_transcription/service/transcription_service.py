from faster_whisper import WhisperModel
from loguru import logger
from django.dispatch import receiver
from django.db.models.signals import post_save
from transcription.models import Transcription

from transcription.audio_transcription.model.transcription_model import TranscriptionModel, SegmentModel


def initialize_model(model_size: str = "medium") -> WhisperModel:
    logger.info(f"Initializing model {model_size}...")
    model: WhisperModel = WhisperModel(model_size, device="cpu", compute_type="int8")
    return model


def transcribe_audio(audio_file: str, model: WhisperModel) -> Transcription:
    logger.info("Transcribing audio...")


if __name__ == '__main__':
    model = initialize_model()
    result = transcribe_audio("../../../harvey.mp3", model)
    logger.info(result)
