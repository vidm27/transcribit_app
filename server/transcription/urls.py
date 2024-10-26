from django.urls import path, include
from rest_framework_nested import routers
from .views import TranscriptionView, SegmentView, StateView

# Crear el router principal
router = routers.DefaultRouter()
router.register(r'transcription', TranscriptionView, basename='transcription')
router.register(r'segment', SegmentView, basename='segment')
router.register(r'state', StateView, basename='state')

urlpatterns = [
    path('', include(router.urls))
]
