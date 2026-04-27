# Generated migration to create procesos_coformacion table

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('coformacion', '0013_create_proceso_coformacion_table'),
    ]

    operations = [
        migrations.RunSQL(
            sql="""
            CREATE TABLE IF NOT EXISTS `procesos_coformacion` (
              `proceso_id` int NOT NULL AUTO_INCREMENT,
              `estudiante_id` int NOT NULL,
              `empresa_id` int NOT NULL,
              `estado_id` int NOT NULL,
              `fecha_inicio_fase_coformacion` date NOT NULL,
              `fecha_fin_fase_practica` date DEFAULT NULL,
              `fecha_ingreso_empresa` date DEFAULT NULL,
              `fecha_finalizacion_empresa` date DEFAULT NULL,
              `fecha_carta_presentacion` date DEFAULT NULL,
              `horario` longtext,
              `forma_de_pago` decimal(10,2),
              `trabaja_sabado` tinyint(1),
              `salario` decimal(10,2),
              `modalidad_vinculacion` varchar(10) NOT NULL,
              `carta_presentacion_enviada` varchar(2) NOT NULL,
              `carta_presentacion_recibida` varchar(2) NOT NULL,
              `modalidad_coformacion` varchar(10) NOT NULL,
              `observaciones` longtext,
              `fecha_creacion` datetime,
              `fecha_actualizacion` datetime,
              PRIMARY KEY (`proceso_id`),
              KEY `idx_fecha_inicio` (`fecha_inicio_fase_coformacion`),
              KEY `procesos_coformacion_estudiante_id_fk` (`estudiante_id`),
              KEY `procesos_coformacion_empresa_id_fk` (`empresa_id`),
              KEY `procesos_coformacion_estado_id_fk` (`estado_id`),
              CONSTRAINT `procesos_coformacion_estudiante_id_fk` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`estudiante_id`) ON DELETE CASCADE,
              CONSTRAINT `procesos_coformacion_empresa_id_fk` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`empresa_id`) ON DELETE CASCADE,
              CONSTRAINT `procesos_coformacion_estado_id_fk` FOREIGN KEY (`estado_id`) REFERENCES `estado_proceso` (`estado_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
            """,
            reverse_sql="""
            DROP TABLE IF EXISTS `procesos_coformacion`;
            """,
        ),
    ]
