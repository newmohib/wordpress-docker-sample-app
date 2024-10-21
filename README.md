### Run the wordpress applicaiton with MySQL DB contianer
- chmod +x script.sh && ./script.sh

### update DB config
- if you need update or use remove db then you can edit wp-config.php file

### update run port 
- if you need to any update for wordpress app run port then edit docker-compose.yml file

### edit image name:
-  if we need to image name edit then 
 - edit to script.sh
 - edit to docker-compose.yml

#### Remove all container and image
- Remove all container
- docker container rm -f $( docker container ls -aq )
- Remove all image
- docker image rm -f $(docker image ls -q)

#### added volume from host 
- volumes:
   mysql_data:
     driver: local
- this mysql_data is will use for db container as store db data and mount this

### Run push image to dockurhub 
- chmod +x pushToHubAndRun.sh && ./pushToHubAndRun.sh
