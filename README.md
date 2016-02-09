tmate unattended
=====

Brief description
-----------
This tool automatize *tmate* to connect, like a reverse tunnel, to machines where direct connection is not possible.

From the machine to which we want to connect (*box* from now on), the script **send_connection.sh** is executed automatically (using *cron* for example). This file creates a tmate session (if not exists), blocks it with *vlock*, and sends the session URL to a remote host (*server* from now on).

On the *server* machine, this URL is received and saved by the script **save_remote_connection.sh**. The URL is saved in a MySQL database. This DB can be consulted to obtain the ssh URL and connect to *box*.

Install server
-----------
* SSH server listening on the default port (22).

* User created with remote ssh access

* Save the ssh keys inside /etc/ssh is recommended, in order to be able to change this *server* from machine in the future.

* If we change *server* from machine without copying the old ssh keys, the *box* machines can always use the new keys if the **known_hosts** file is removed in every *box*. 

* MySQL server installed, with a BD created. Edit the file **create_table_and_user.sql** with a new BD_USER and BD_PASSWD to connect to the new table that is going to be created.
```
> source create_table_and_user.sql
```

* Edit save_remote_connection.sh with the BD data, and move it to the server.
```
$mv save_remote_connection.sh [USER_HOME]
$chmod +x [USER_HOME]/save_remote_connection.sh
```

* As an example the file **index.php** can be used to read the BD from a web browser, editing it with the BD data and giving it and user and a password (to protect the URL sessions).

Install box
-----------
* Install packages:
lsblk ssh sshpass tmux tmate vlock shc

* Configure ssh to ignore server ip and only use the domain name and public key. This is useful in case you want to change *server* from machine in the future. At the end of the file /etc/ssh/ssh_config write:
```
Host [REMOTE_HOST]
	CheckHostIp no
```

* Edit the **send_connection.sh** with the *server* data. Then encrypt it through **shc**, giving only execution permissions to everyone. For security, remove the .sh script and the other files generated. 
```
$ shc -T -f send_connection.sh
$ chmod 111 send_connection.sh.x
$ rm send_connection.sh send_connection.sh.x.c
```

* Execute **send_connection.sh.x** periodically (for example using CRON).

