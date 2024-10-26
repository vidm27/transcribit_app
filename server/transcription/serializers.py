from rest_framework import serializers

from .models import Transcription, Segment, State


class SegmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Segment
        fields = '__all__'


class StateSerializer(serializers.ModelSerializer):
    class Meta:
        model = State
        fields = '__all__'


class TranscriptionSerializer(serializers.ModelSerializer):
    state = serializers.StringRelatedField(read_only=True)
    segments = SegmentSerializer(many=True, read_only=True)

    class Meta:
        model = Transcription
        fields = '__all__'
