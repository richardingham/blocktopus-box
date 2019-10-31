cd /app

if [ ! -d "data/experiments" ]
then
  python /src/octopus-editor/initialise.py
fi

twistd --nodaemon --pidfile=twistd.pid octopus-editor --wshost 127.0.0.1