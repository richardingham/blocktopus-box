apt-get update
apt-get install -y python2.7 python-pip nodejs-legacy npm

pip install twisted numpy scipy pandas xlsxwriter
pip install crc16 pyserial
pip install cryptography pyasn1
pip install autobahn jinja2
pip install wget

# apt-get install -y libsm6 libxext6
# pip install opencv-python
# pip install pygame SimpleCV

cd /home/vagrant

if [ ! -d "octopus" ]
then
  git clone https://github.com/richardingham/octopus.git
fi
if [ ! -d "octopus-editor-server" ]
then
  git clone https://github.com/richardingham/octopus-editor-server.git
fi

cd /home/vagrant/octopus
git pull

cd /home/vagrant/octopus-editor-server
git pull
npm install
node_modules/.bin/rollup -c

echo "/home/vagrant/octopus" >> /usr/lib/python2.7/dist-packages/octopus.pth
echo "/home/vagrant/octopus-editor-server" >> /usr/lib/python2.7/dist-packages/octopus-server.pth
echo 'PATH="$PATH:$HOME/.local/bin"' > /home/vagrant/.profile

cd /vagrant

if [ ! -d "data" ]
then
  python /home/vagrant/octopus-editor-server/initialise.py
fi

if [ $(ls -A override_manufacturer/* 2>/dev/null) ]
then
  cp -b -R override_manufacturer/* /home/vagrant/octopus/octopus/manufacturer
fi

cp octopus.service /etc/systemd/system/octopus.service
systemctl enable octopus
systemctl daemon-reload
systemctl start octopus
