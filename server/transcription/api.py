from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns

from .views import TranscriptionList, TranscriptionDetail

urlpatterns = [
    path('trancription/', TranscriptionList.as_view(), name='transcription_list'),
    path('transcription/<int:pk>', TranscriptionDetail.as_view(), name='transcription_detail'),
    path('transcription/<int:pk>/segment/', TranscriptionDetail.as_view(), name='transcription_segment'),
]

# urlpatterns = format_suffix_patterns(urlpatterns)