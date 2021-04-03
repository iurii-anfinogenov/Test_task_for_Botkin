t_task_for_Botkin
Поднять в docker-compose две разных базы данных, сгенерировать данные и положить в базу A, вытащить и модифицировать из базы A и положить в базу B.  Проверяем навыки работы с docker\docker-compose (проброс портов\volume), bash скрипты, SQL (DDL\DML).  
* Для теста используется OS Ubuntu 20.04
# Установка Docker:

1. sudo apt update
2. sudo apt install apt-transport-https ca-certificates curl software-properties-common
3. curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
4. sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
5. sudo atp update
6. apt-cache policy docker-ce
Получаем вывод.
     docker-ce:
  Installed: (none)
  Candidate: 5:19.03.9~3-0~ubuntu-focal
  Version table:
     5:19.03.9~3-0~ubuntu-focal 500
        500 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages

sudo apt install docker-ce
        
# Установка Docker-compouse    

1. sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
2. sudo chmod +x /usr/local/bin/docker-compose
