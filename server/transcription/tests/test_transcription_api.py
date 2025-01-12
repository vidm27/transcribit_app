from rest_framework.test import APIRequestFactory

factory = APIRequestFactory()

request = factory.get('/api/v1/transcription/')