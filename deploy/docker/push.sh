
if [ -z $1 ]; then
  echo "命令行错误，请输入版本号。例如："
  echo "sh ./deploy/docker/build.sh 1.0"
  exit
fi

ver=$1
cr="047268420102.dkr.ecr.ap-south-1.amazonaws.com/xyz-shop"



docker push $cr/review:$ver 
docker push $cr/product:$ver 