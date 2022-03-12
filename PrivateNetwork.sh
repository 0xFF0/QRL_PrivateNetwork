start_time=$(date +%s)

sudo apt update

# Install Required dependencies
sudo apt-get -y install swig3.0 python3-dev python3-pip build-essential pkg-config libssl-dev libffi-dev libhwloc-dev libboost-dev cmake

# Make sure setuptools is the latest
pip3 install -U setuptools
pip3 install testresources

# Installing requirements
cat << EOF | xargs --max-args=1 --max-procs=8 sudo pip install
plyvel==1.2.0
ntplib==0.3.4
Twisted==20.3.0
colorlog==3.1.0
simplejson==3.11.1
PyYAML==5.3.1
grpcio-tools>=1.9.0,<=1.27.2
grpcio>=1.9.0,<=1.27.2
google-api-python-client==1.8.3
google-auth<2.0dev,>=1.21.1
httplib2>=0.15.0
service_identity==17.0.0
protobuf==3.15.8
pyopenssl==17.5.0
six==1.13.0
click==7.1.2
pyqrllib>=1.2.3,<1.3.0
pyqryptonight>=0.99.9
pyqrandomx>=0.3.0,<1.0.0
Flask>=1.0.0,<=1.1.2
json-rpc==1.10.8
idna==2.6
cryptography==2.3
mock==2.0.0
daemonize==2.4.7
EOF

# Install QRL
pip3 install -U qrl

if [ ! -d ~/.qrl ]; then
  mkdir ~/.qrl
fi


cat <<EOF >> ~/.qrl/config.yml
genesis_difficulty: 500
mining_enabled: True
peer_list: []
EOF

# Reload profile
. ~/.profile

ADDR=$(qrl wallet_gen --height 8 | grep -o -E "Q0104[a-z0-9]*")

start_qrl --miningAddress $ADDR --mockGetMeasurement 1000000000 --quiet &

sleep 2
qrl state && qrl wallet_ls

end_time=$(date +%s)
elapsed=$(( end_time - start_time ))

echo "Time spent: $elapsed seconds"
