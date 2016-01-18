#rm -rf aroundyou
#git clone <git_repository> 

#pushd aroundyou
#mvn clean install
#popd

warjarfilepath=<targetfilepath>

user=ubuntu
IP=152.194.192.120
pwd=*********
date=`date +%Y_%m_%d_%H:%M:%S`

if [[ -f "$warjarfilepath/AYApps.war" && -f "$warjarfilepath/AYApps.one-jar.jar" ]]
then  
	echo "AYApps.war and AYApps.one-jar.jar both exist in $warjarfilepath"  
else
	echo "one or more is missing from $warjarfilepath"
fi

echo "Taking backup of .war"
sshpass -p $pwd ssh $user@$IP "mkdir -pv /home/ubuntu/backup/$date;cp -v /home/ubuntu/apache-tomcat-7.0.63/webapps/AYApps.war /home/ubuntu/backup/$date/"

echo "Deploying new war"
sshpass -p $pwd scp -r $warjarfilepath/AYApps.war $user@$IP:/home/ubuntu/apache-tomcat-7.0.63/webapps/

echo "Taking backup of jar"
sshpass -p $pwd ssh $user@$IP "mkdir -pv /home/ubuntu/backup/$date;cp -v /home/ubuntu/AroundYouWorkers/AYApps.one-jar.jar /home/ubuntu/backup/$date/"


echo "Copying workers scripts"
sshpass -p $pwd ssh $user@$IP "mkdir -pv /home/ubuntu/AroundYouWorkers/AYWorkerLogs"
#sshpass -p $pwd scp -r executeWorker.sh startWorker.sh $user@$IP:/home/ubuntu/AroundYouWorkers/
#sshpass -p $pwd ssh $user@$IP "pushd /home/ubuntu/AroundYouWorkers;chmod 777 executeWorker.sh;chmod 777 startWorker.sh"


echo "Copying new jar"
sshpass -p $pwd scp -r $warjarfilepath/AYApps.one-jar.jar $user@$IP:/home/ubuntu/AroundYouWorkers/


echo "Stopping and Starting new worker at remote"
sshpass -p $pwd ssh $user@$IP "pushd /home/ubuntu/AroundYouWorkers/;./stopAndRestartWorker.sh;popd"

echo "**** end of script ****"