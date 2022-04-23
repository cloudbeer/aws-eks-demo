
if [ -z $1 ]; then
  echo "命令行错误，请输入版本号。例如："
  echo "sh ./deploy/docker/build.sh 1.0"
  exit
fi

ver=$1
cr="047268420102.dkr.ecr.ap-south-1.amazonaws.com/xyz-shop"
croot=$(pwd)

function label() {
  echo
  echo
  echo "--------------------------------------"
  echo ":: 构建 $1"
  echo "--------------------------------------"
  echo
  echo
}


########################
label "review"
cd $croot/src/review
docker build -t $cr/review:$ver .


#####################
label "product"
cd $croot/src/product
mvn clean package -DskipTests
docker build -t $cr/product:$ver .


