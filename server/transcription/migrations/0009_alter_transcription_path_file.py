# Generated by Django 5.1.2 on 2024-11-09 19:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('transcription', '0008_transcription_title'),
    ]

    operations = [
        migrations.AlterField(
            model_name='transcription',
            name='path_file',
            field=models.FileField(null=True, upload_to=''),
        ),
    ]
