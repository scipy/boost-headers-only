#!/bin/bash

# Which version of Boost?
BOOST_MAJOR=1
BOOST_MINOR=76
BOOST_PATCH=0

# Version formatted representations (dot and underscore)
BOOST_VER_DOT=${BOOST_MAJOR}.${BOOST_MINOR}.${BOOST_PATCH}
BOOST_VER_UND=${BOOST_MAJOR}_${BOOST_MINOR}_${BOOST_PATCH}

# where do I live?
base="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# download tarball (location of tarballs can also be found at https://www.boost.org/users/download/)
echo "Downloading source distribution of Boost ${BOOST_VER_DOT}... "
archive=${base}/boost.${BOOST_VER_DOT}.tar.gz
srctree=${base}/boost_${BOOST_VER_UND}
wget -q --show-progress -O ${archive} https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VER_DOT}/source/boost_${BOOST_VER_UND}.tar.gz
printf "Unpacking... "
tar -xzf ${archive}
echo "Extracted!"

# configure build by calling bootstrap.sh
printf "Starting configure... "
boost_tmp=${base}/boost_with_lib
$(cd ${srctree} && ./bootstrap.sh --prefix=${boost_tmp} --with-libraries=math > ${base}/bootstrap.log)
res=${?}
if [ "${res}" -ne 0 ]; then
    echo "Failed to run Boost ./bootstrap.sh!"
    return 1
fi
echo "Success!"

# Do the build, will create some binaries but we will ignore these
printf "Starting build... "
$(cd ${srctree} && ./b2 install > ${base}/b2.log)
res=${?}
if [ "${res}" -ne 0 ]; then
    echo "Failed to run Boost ./b2!"
    return 1
fi
# ensure the include/ directory really does exist where we think it does
if [ ! -d "${boost_tmp}/include" ]; then
    echo "Headers failed to generate!"
    return 1
fi
echo "Success!"

# Remove old headers and replace with new headers and move License, README
echo "Updating header files!"
rm -r ${base}/boost/
mv ${boost_tmp}/include/boost/ ${base}/
mv ${srctree}/LICENSE_1_0.txt ${base}/
mv ${srctree}/README.md ${base}/Boost_${BOOST_VER_UND}_README.md

# Cleanup
printf "Cleaning up... "
rm -r ${boost_tmp}/
rm -r ${srctree}/
rm ${archive}
echo "Done!"
