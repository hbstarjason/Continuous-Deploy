TEKTON_PATH='tekton'
TEKTON_VER='v0.9.0'
REGISTRY_URL='hbstarjason'

rm -rf $TEKTON_PATH
mkdir $TEKTON_PATH


# download yaml
echo "download yaml files ..."

cd $TEKTON_PATH

wget -q https://storage.googleapis.com/tekton-releases/latest/release.yaml

cd ..

# get images list
echo "collect image to tmp file ..."

cd $TEKTON_PATH
rm -rf image.tmp

for line in `grep -RI " image: " *.yaml | grep gcr.io`
do
	if [[ ${line} =~ 'gcr.io' ]]
	then
		if [[ ${line} =~ 'gcr.io/tekton-releases/github.com/tektoncd' ]]
		then
			sub_line1=${line##gcr.io/tekton-releases/github.com/tektoncd/}
			sub_line2=${sub_line1%%@sha*}
			container_name=tekton_${sub_line2//\//_}

			echo ${line#image:} ${REGISTRY_URL}/${container_name}:${TEKTON_VER} >> image.tmp
		else
			sub_line1=${line#image:}
			sub_line2=${sub_line1#*/}
			sub_line3=${sub_line2%%:*}
			container_name=tekton_${sub_line3//\//_}

			echo ${line#image:} ${REGISTRY_URL}/${container_name}:${TEKTON_VER} >> image.tmp;
		fi
	fi
done

for line in `grep -RI " - " *.yaml | grep gcr.io`
do 
	if [[ ${line} =~ 'gcr.io' ]]
	then
		if [[ ${line} =~ 'gcr.io/tekton-releases/github.com/tektoncd' ]]
		then 
			sub_line1=${line##gcr.io/tekton-releases/github.com/tektoncd/}
			sub_line2=${sub_line1%%@sha*}
			container_name=tekton_${sub_line2//\//_}

			echo ${line#value:} ${REGISTRY_URL}/${container_name}:${TEKTON_VER} >> image.tmp
		else 
			sub_line1=${line#value:}
			sub_line2=${sub_line1#*/}
			sub_line3=${sub_line2%%:*}
			container_name=tekton_${sub_line3//\//_}

			echo ${line#value:} ${REGISTRY_URL}/${container_name}:${TEKTON_VER} >> image.tmp;
		fi 
	fi
done


cd ..


# replace file image

cd $TEKTON_PATH

counter=0
for file in *.yaml
do
    echo "开始处理文件 " $file

	while read line
	do
		origin_image=`echo ${line} | awk '{print $1}'`
		new_image=`echo ${line} | awk '{print $2}'`

	    tmp=${origin_image//\//__}
	    origin_image=${tmp//__/\\/}

	    tmp2=${new_image//\//__}
	    new_image=${tmp2//__/\\/}

	    sed -i "s/${origin_image}/${new_image}/g" ${file}   
	    #上面这行，如果是MacOS/UNIX请替换为: sed -i " " "s/${origin_image}/${new_image}/g" ${file}

	done < image.tmp
	counter=`expr ${counter} + 1`
done

echo "共处理文件数：" ${counter}

rm -rf *.yaml.1
cd ..

# finish
echo "completed..."