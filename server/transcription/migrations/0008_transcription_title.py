# Generated by Django 5.1.2 on 2024-11-04 22:53

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('transcription', '0007_alter_segment_segment_edit'),
    ]

    operations = [
        migrations.AddField(
            model_name='transcription',
            name='title',
            field=models.CharField(max_length=255, null=True),
        ),
    ]
