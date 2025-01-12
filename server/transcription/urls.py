from django.urls import path, include
from rest_framework_nested import routers
from .views import TranscriptionView, SegmentView, StateView, AudioFileView

# Crear el router principal
router = routers.DefaultRouter()
router.register(r'transcription', TranscriptionView, basename='transcription')
router.register(r'segment', SegmentView, basename='segment')
router.register(r'state', StateView, basename='state')

urlpatterns = [
    path('', include(router.urls)),
    path('audio/<str:transcription_id>', AudioFileView.as_view(), name='audio-download'),
]
