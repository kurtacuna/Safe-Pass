# Generated by Django 5.2.1 on 2025-05-30 07:04

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='AppSettings',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('session_timeout', models.IntegerField(default=60)),
                ('enable_scheduled_reminders', models.BooleanField(default=False)),
                ('max_visitors_per_day', models.IntegerField(default=50)),
                ('max_visit_duration', models.IntegerField(default=120)),
            ],
            options={
                'verbose_name': 'App Setting',
                'verbose_name_plural': 'App Settings',
            },
        ),
    ]
