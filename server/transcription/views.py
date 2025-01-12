# from django.core.signals import request_finished
from django.http import FileResponse
from requests import Response
from rest_framework import status
from rest_framework import viewsets
from rest_framework.views import APIView

from transcription.serializers import TranscriptionSerializer, SegmentSerializer, StateSerializer
from .models import Transcription, Segment, State


class TranscriptionView(viewsets.ModelViewSet):
    serializer_class = TranscriptionSerializer
    queryset = Transcription.objects.select_related('state').all()

    def create(self, request, *args, **kwargs):
        transcription = super().create(request, *args, **kwargs)
        print(f"Transcripción creada: {transcription.data}")

        return transcription

    def retrieve(self, request, *args, **kwargs):
        print(f"Transcripción solicitada: {kwargs['pk']}")
        transcription = super().retrieve(request, *args, **kwargs)
        print(f"Transcripción recuperada: {transcription.data}")

        return transcription

    def update(self, request, *args, **kwargs):
        transcription = super().update(request, *args, **kwargs)
        print(f"Transcripción actualizada: {transcription.data}")
        return transcription

    def destroy(self, request, *args, **kwargs):
        transcription = super().destroy(request, *args, **kwargs)
        print(f"Transcripción eliminada: {transcription.data}")

        return transcription


class SegmentView(viewsets.ModelViewSet):
    serializer_class = SegmentSerializer
    queryset = Segment.objects.all()

    def retrieve(self, request, *args, **kwargs):
        # print(f"Segmento solicitado: {kwargs['pk']}")
        segment = super().retrieve(request, *args, **kwargs)
        print(f"Segmento recuperado: {segment.data}")
        return segment


class StateView(viewsets.ModelViewSet):
    serializer_class = StateSerializer
    queryset = State.objects.all()


class AudioFileView(APIView):


    def get(self, request, transcription_id, *args, **kwargs):
        try:
            transcription = Transcription.objects.get(id=transcription_id)
            print(f"Audio solicitado: {transcription.path_file.path}")

            response = FileResponse(open(transcription.path_file.path, 'rb'), content_type='audio/mpeg')
            response['Content-Disposition'] = f'attachment; filename="{transcription.path_file.name}"'
            return response
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
