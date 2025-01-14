# Generated by Django 5.1.2 on 2024-10-26 04:48

import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('transcription', '0003_state_transcription_state'),
    ]

    operations = [
        migrations.AlterField(
            model_name='segment',
            name='id',
            field=models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='state',
            name='id',
            field=models.IntegerField(editable=False, primary_key=True, serialize=False),
        ),
    ]
