from unittest.mock import MagicMock

from faster_whisper import WhisperModel

from transcription.audio_transcription.service.transcription_service import initialize_model, transcribe_audio, Transcription


def test_initialize_model():
    model = initialize_model("medium")

    assert isinstance(model, WhisperModel)


def test_transcribe_audio():
    mock_model = MagicMock(spec=WhisperModel)

    mock_segments = [
        MagicMock(start=0.0, end=3.5, text="Hola mundo"),
        MagicMock(start=3.6, end=7.0, text="¿Cómo estás?")
    ]
    mock_info = MagicMock(language="es", language_probability=0.98, duration=7.0)

    mock_model.transcribe.return_value = (mock_segments, mock_info)

    result = transcribe_audio("harvey.mp3", mock_model)
    assert isinstance(result, Transcription)

    assert result.language == "es"
    assert result.language_probability == 0.98
    assert result.duration == 7.0

    # Verificamos que los segmentos sean correctos
    assert len(result.segments) == 2
    assert result.segments[0].text == "Hola mundo"
    assert result.segments[1].text == "¿Cómo estás?"
