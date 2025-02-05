#!/bin/bash

# Variables de configuración
DB_USER="tu_usuario"
DB_PASSWORD="tu_contraseña"
DB_NAMES=("bd1" "bd2")
BACKUP_DIR="/ruta/a/la/carpeta/de/backup"
LOG_FILE="/ruta/a/logs/backup.log"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Validar las variables de configuración
if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ] || [ -z "$BACKUP_DIR" ]; then
    echo "Error: Las variables de configuración no están completas." | tee -a $LOG_FILE
    exit 1
fi

# Crear la carpeta de backup si no existe
mkdir -p $BACKUP_DIR

# Eliminar backups antiguos de más de 7 días
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +7 -exec rm -f {} \; | tee -a $LOG_FILE

# Hacer backup de cada base de datos
for DB_NAME in "${DB_NAMES[@]}"; do
    BACKUP_FILE="$BACKUP_DIR/backup_$DB_NAME_$DATE.sql.gz"
    echo "Iniciando backup de $DB_NAME..." | tee -a $LOG_FILE

    # Verificar si la base de datos existe
    DB_EXISTS=$(mysql -u $DB_USER -p$DB_PASSWORD -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME" > /dev/null; echo $?)
    if [ $DB_EXISTS -ne 0 ]; then
        echo "Error: La base de datos $DB_NAME no existe." | tee -a $LOG_FILE
        continue
    fi

    # Realizar el backup y comprimir el archivo
    mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME | gzip > $BACKUP_FILE 2>&1 | tee -a $LOG_FILE
    if [ $? -eq 0 ]; then
        echo "Backup de $DB_NAME completado exitosamente." | tee -a $LOG_FILE
    else
        echo "Error al hacer el backup de $DB_NAME." | tee -a $LOG_FILE
    fi
done

# Notificación por correo (opcional)
if [ $? -eq 0 ]; then
    echo "Backup completado con éxito" | mail -s "Backup MySQL Exitoso" tu-email@dominio.com
else
    echo "Backup fallido" | mail -s "Error en Backup MySQL" tu-email@dominio.com
fi
