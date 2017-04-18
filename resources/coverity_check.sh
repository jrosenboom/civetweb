#! /bin/sh

# check if we use the correct directory
ls src/civetweb.c
if [ "$?" = "0" ]; then
	echo "Building files for coverity check ..."
else
	echo "Run this script from the root directory of project!" 1>&2
	echo "username@hostname:/somewhere/civetweb$ ./resources/coverity_check.sh" 1>&2
	exit 1
fi

# remove last build
rm -rf cov_build/

# copy files to build folder
mkdir cov_build
mkdir cov_build/src
mkdir cov_build/include
mkdir cov_build/resources

cp Makefile cov_build/
cp src/*.c cov_build/src/
cp src/*.inl cov_build/src/
cp include/civetweb.h cov_build/include/
cp resources/Makefile.in-os cov_build/resources/

cd cov_build

# new scan build
../../cov-analysis-linux64-8.7.0/bin/cov-build  --dir cov-int make WITH_IPV6=1 WITH_WEBSOCKET=1


# pack build results for upload
tar czvf civetweb_coverity_check.tgz cov-int

cd ..

# check if the build was successful
echo
ls -la cov_build/civetweb_coverity_check.tgz

if [ "$?" = "0" ]; then
	echo "... done"
        echo
else
	echo "No civetweb_coverity_check.tgz file" 1>&2
        echo
	exit 1
fi

# return "ok"
exit 0

