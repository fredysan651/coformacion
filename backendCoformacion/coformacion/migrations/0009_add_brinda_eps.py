from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('coformacion', '0008_create_proceso_coformacion'),
    ]

    operations = [
        # Placeholder migration - tabla ya existe o será creada por fixture/dump
        migrations.RunSQL(
            sql="SELECT 1;",
            reverse_sql="SELECT 1;",
        ),
    ]
