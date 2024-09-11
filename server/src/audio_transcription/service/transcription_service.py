from faster_whisper import WhisperModel
from loguru import logger
from pydantic import BaseModel


class Segment(BaseModel):
    start: float
    end: float
    text: str

    # Sobreescribimos el método __str__
    def __str__(self):
        return f"Segmento desde {self.start:.2f} hasta {self.end:.2f}: '{self.text}'"


class Transcription(BaseModel):
    language: str
    language_probability: float
    duration: float
    segments: list[Segment]

    def __str__(self):
        segment_str = "\n".join([str(segment) for segment in self.segments])
        return (f"Transcripción en {self.language} (probabilidad: {self.language_probability:.2f}), "
                f"duración: {self.duration:.2f} segundos:\n{segment_str}")


def initialize_model(model_size: str = "medium") -> WhisperModel:
    logger.info(f"Initializing model {model_size}...")
    model: WhisperModel = WhisperModel(model_size, device="cpu", compute_type="int8")
    return model


def transcribe_audio(audio_file: str, model: WhisperModel) -> Transcription:
    logger.info("Transcribing audio...")

    segments, info = model.transcribe(audio_file, beam_size=5)

    return Transcription(
        language=info.language,
        language_probability=info.language_probability,
        duration=info.duration,
        segments=[Segment(start=segment.start, end=segment.end, text=segment.text)
                  for segment in segments],
    )


if __name__ == '__main__':
    model = initialize_model()
    result = transcribe_audio("harvey.mp3", model)
    logger.info(result)
