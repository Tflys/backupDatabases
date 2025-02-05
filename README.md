backupDatabases 🗃️
---
backupDatabases es un script de Bash que automatiza la creación de copias de seguridad (backups) de bases de datos MySQL. El script realiza un backup completo de las bases de datos especificadas, comprime los archivos y los guarda en un directorio configurable. Además, incluye funcionalidades como la eliminación de backups antiguos, la verificación de la existencia de bases de datos y la posibilidad de recibir notificaciones por correo electrónico en caso de éxito o error.

---

Características ✨
✅ Automatización completa de backups de bases de datos MySQL.
🗂️ Compresión de archivos de respaldo en formato .gz.
🧹 Eliminación automática de backups antiguos (configurable).
🛠️ Verificación de la existencia de las bases de datos antes de realizar el backup.
📜 Registro de logs detallado para facilitar el seguimiento.
📧 Notificaciones por correo electrónico en caso de éxito o error.
⚙️ Compatible con múltiples bases de datos.

---
Requisitos ⚡
Bash (compatible con sistemas Linux/macOS).
MySQL: Debes tener acceso a las bases de datos que deseas respaldar.
Correo electrónico (si deseas recibir notificaciones por correo, asegúrate de tener configurado mail o un servicio similar).
AWS CLI (opcional, si deseas subir los backups a un bucket de S3).

---
Instalación 🔧
1. Clona el repositorio
bash

git clone https://github.com/Tflys/backupDatabases.git
cd backupDatabases
2. Configura las variables en el script
Edita el archivo backup_mysql.sh y ajusta las siguientes variables de configuración:

bash

DB_USER="tu_usuario"
DB_PASSWORD="tu_contraseña"
DB_NAMES=("bd1" "bd2")
BACKUP_DIR="/ruta/a/la/carpeta/de/backup"
LOG_FILE="/ruta/a/logs/backup.log"
DB_USER: Usuario de MySQL con permisos de backup.
DB_PASSWORD: Contraseña del usuario de MySQL.
DB_NAMES: Lista de bases de datos para hacer backup.
BACKUP_DIR: Ruta donde se guardarán los archivos de backup.
LOG_FILE: Ruta donde se guardará el archivo de logs.
3. Permisos de ejecución
Asegúrate de que el script tenga permisos de ejecución:

bash

chmod +x backup_mysql.sh
Ejecutar el script 🏃‍♂️
Para ejecutar el script manualmente:

bash

./backup_mysql.sh
---

Programar backups automáticos ⏰
Puedes configurar el script para que se ejecute automáticamente a través de cron. Por ejemplo, para ejecutarlo todos los días a las 2 AM:

---
Abre el crontab:

bash
Copiar
Editar
crontab -e
Añade la siguiente línea al final:

bash
Copiar
Editar
0 2 * * * /ruta/a/backupDatabases/backup_mysql.sh

---

Opciones avanzadas 🔍
Eliminar backups antiguos 🗑️
Por defecto, el script elimina los backups de más de 7 días. Puedes modificar este valor ajustando el parámetro -mtime +7 en el comando find del script.

Subir a AWS S3 (opcional) 🌐
Si deseas subir tus backups a un bucket de AWS S3, agrega el siguiente código al final del script:

bash
Copiar
Editar
aws s3 cp $BACKUP_FILE s3://tu-bucket-de-backups/$DATE/ --region tu-region
Notificación por correo electrónico 📧
Si deseas recibir notificaciones por correo, asegúrate de tener configurado un servicio de correo como mail. Para recibir una notificación al final del proceso, agrega lo siguiente:

bash
Copiar
Editar
if [ $? -eq 0 ]; then
    echo "Backup completado con éxito" | mail -s "Backup MySQL Exitoso" tu-email@dominio.com
else
    echo "Backup fallido" | mail -s "Error en Backup MySQL" tu-email@dominio.com
fi

---
Licencia 📜
Este proyecto está bajo la Licencia MIT. Puedes consultar el archivo LICENSE para más detalles.
---
