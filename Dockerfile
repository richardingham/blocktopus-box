FROM node:13-alpine

RUN apk update
RUN apk add python2 python2-dev py2-pip build-base

RUN node --version && \
	npm --version && \
	python --version && \
	pip --version

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk add --update --no-cache ca-certificates gcc g++ curl openblas-dev@community

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN pip install --no-cache-dir --disable-pip-version-check numpy==1.13.0rc1
RUN pip install --no-cache-dir --disable-pip-version-check scipy==0.19.0

RUN pip install --no-cache-dir --disable-pip-version-check pandas
RUN pip install --no-cache-dir --disable-pip-version-check twisted==18.9.0
RUN pip install --no-cache-dir --disable-pip-version-check xlsxwriter
RUN pip install --no-cache-dir --disable-pip-version-check crc16
RUN pip install --no-cache-dir --disable-pip-version-check pyserial

RUN apk add --no-cache libffi-dev openssl-dev musl-dev
RUN pip install --no-cache-dir --disable-pip-version-check cryptography
RUN pip install --no-cache-dir --disable-pip-version-check pyasn1
RUN pip install --no-cache-dir --disable-pip-version-check autobahn
RUN pip install --no-cache-dir --disable-pip-version-check jinja2
RUN pip install --no-cache-dir --disable-pip-version-check wget
RUN pip install --no-cache-dir --disable-pip-version-check bcrypt

ARG OCTOPUS_REVISION=master
ARG EDITOR_REVISION=master

WORKDIR /src
RUN wget --no-check-certificate -O octopus.zip https://github.com/richardingham/octopus/archive/${OCTOPUS_REVISION}.zip; \
wget --no-check-certificate -O octopus-editor.zip https://github.com/richardingham/octopus-editor-server/archive/${EDITOR_REVISION}.zip; \
unzip octopus.zip; \
rm octopus.zip; \
unzip octopus-editor.zip; \
rm octopus-editor.zip; \
mv octopus-${OCTOPUS_REVISION} octopus; \
mv octopus-editor-server-${EDITOR_REVISION} octopus-editor; \
echo "/src/octopus" >> /usr/lib/python2.7/site-packages/octopus.pth; \
echo "/src/octopus-editor" >> /usr/lib/python2.7/site-packages/octopus-editor.pth

WORKDIR /src/octopus-editor
RUN npm install && ./node_modules/.bin/rollup -c

COPY override_manufacturer/* /src/octopus/octopus/manufacturer

WORKDIR /app
COPY start.sh .
RUN ["chmod", "+x", "start.sh"]

CMD ./start.sh

