from pydantic import BaseModel


class SegmentModel(BaseModel):
    start: float
    end: float
    text: str

    # Sobreescribimos el método __str__
    def __str__(self):
        return f"Segmento desde {self.start:.2f} hasta {self.end:.2f}: '{self.text}'"


class TranscriptionModel(BaseModel):
    language: str
    language_probability: float
    duration: float
    segments: list[SegmentModel]

    def __str__(self):
        segment_str = "\n".join([str(segment) for segment in self.segments])
        return (f"Transcripción en {self.language} (probabilidad: {self.language_probability:.2f}), "
                f"duración: {self.duration:.2f} segundos:\n{segment_str}")
