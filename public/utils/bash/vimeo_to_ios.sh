#Assumes this is run from the directory containing the larger videos
#Creates iosvideos one level directory up
if [ ! -d "../iosvideos" ]; then 
	mkdir "../iosvideos" 
fi

for f in *.mp4; do 
	echo $f
	if [ -f "../iosvideos/$f" ];
	then
	   echo "File $f exists"
	else
  	  ffmpeg -i $f -b:v 200k -r 24 -ar 22050 -b:a 56k -vf scale=400:224 "../iosvideos/$f"
	fi
done

cd ..
