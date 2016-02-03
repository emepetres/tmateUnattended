Acceso remoto a equipos sin conexión directa (Tmate)
=====

Funcionamiento
-----------
Tmate crea una sesión de Tmux remota usando sus propios servidores y proporcionando una dirección ssh para conectarse remotamente (parecído a un tunel inverso SSH).

Desde el cliente mediante el comando **send_connection.sh**, se comprueba si tenemos las claves del servidor rtunnel, y posteriormente se crea si no existe una sesión de Tmate. Esta sesión se bloquea mediante Vlock, y se envia la dirección ssh proporcionada por Tmate al servidor ```[REMOTE_HOST]``` mediante una conexión ssh normal.

En ```[REMOTE_HOST]``` mediante **save_remote_connection.sh** se recibe dicha dirección y se guarda en una base de datos Mysql. Posteriormente esta base de datos puede consultarse para obtener la dirección ssh de Tmate y conectarse al cliente.

Instalación servidor
-----------
* Servidor ssh instalado escuchando puerto por defecto
* Usuario "```[SSH_USER]```", clave "```[SSH_PASSWD]```"
```
#GatewayPorts clientspecified >> /etc/ssh/sshd.config
$mv remote_connection.sh ```[SSH_USER_HOME]```
$chmod +x /home/rtunnel/remote_connection.sh
```

* Es conveniente guardar las claves del servidor que se encuentran en /etc/ssh, ya que si cambiamos el servidor, será necesario usar estas mismas claves para que las conexiones aparezcan en el nuevo servidor.
```
#mv old_host_keys/* /etc/ssh/ (reescribir)
```

* Si no se pueden reescribir las claves en el nuevo servidor, el cliente puede tomar las 
claves nuevas siempre y cuando no aparezca el servidor en el archivo de known_hosts del cliente. 

* Servidor Mysql instalado, con base de datos ```[BD_NAME]``` creada.
```
> source create_table_and_user.sql
```

Instalación cliente
-----------
* Instalar paquetes:
lsblk ssh sshpass tmux tmate vlock shc

* Configuración ssh:
Al final del archivo /etc/ssh/ssh_config escribir:
Host ```[REMOTE_HOST]```
	CheckHostIp no

* Encriptar send_connection.sh mediante shc y mover el .x a donde se quiera, dándole solo permisos de 
ejecución para todo el mundo (nada de lectura o escritura excepto root)
```
$shc -T -f send_connection.sh
```

* Ejecutar send_connection.sh desde el CRON con la periodicidad que se 
estime oportuna.
