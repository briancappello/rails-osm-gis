FROM ubuntu:16.04

# install utils and build tools
RUN apt-get update && apt-get install -y tar bzip2 unzip curl git sudo \
                                         build-essential autoconf cmake

# install mapnik
RUN apt-get update && apt-get install -y mapnik-utils python-mapnik libmapnik-dev \
                                         fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont

# install deps for osm2pgsql
RUN apt-get update && apt-get install -y libexpat1-dev zlib1g-dev libbz2-dev libproj-dev \
                                         libboost-dev libboost-system-dev libboost-filesystem-dev \
                                         lua5.2 liblua5.2-dev libpq-dev

# build and install osm2pgsql
RUN mkdir /gis && \
    cd /gis && \
    git clone git://github.com/openstreetmap/osm2pgsql.git && \
    cd osm2pgsql && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    make install

# clone openstreetmap-carto, download shapefiles
RUN cd /gis && \
    git clone git://github.com/gravitystorm/openstreetmap-carto.git && \
    cd openstreetmap-carto && \
    python scripts/get-shapefiles.py

# install apache
RUN apt-get update && apt-get install -y apache2 apache2-dev

# build and install mod_tile
RUN cd /gis && \
    git clone git://github.com/SomeoneElseOSM/mod_tile.git && \
    cd mod_tile && \
    ./autogen.sh && \
    ./configure && \
    make install && \
    make install-mod_tile && \
    ldconfig

# configure mod_tile
RUN mkdir /var/lib/mod_tile
RUN echo 'LoadModule tile_module /usr/lib/apache2/modules/mod_tile.so' > /etc/apache2/conf-available/mod_tile.conf
RUN sed -i 's/ServerAdmin.\+/ServerAdmin webmaster@localhost\n\tModTileMissingRequestTimeout 30/' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/ServerAdmin.\+/ServerAdmin webmaster@localhost\n\tModTileRequestTimeout 0/' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/ServerAdmin.\+/ServerAdmin webmaster@localhost\n\tModTileRenderdSocketName \/var\/run\/renderd\/renderd.sock/' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/ServerAdmin.\+/ServerAdmin webmaster@localhost\n\tLoadTileConfigFile \/usr\/local\/etc\/renderd.conf/' /etc/apache2/sites-available/000-default.conf
RUN a2enconf mod_tile

# configure renderd
RUN mkdir /var/run/renderd
RUN sed -i 's/num_threads=[0-9]\+/num_threads=2/' /usr/local/etc/renderd.conf
RUN sed -i 's/XML=.\+/XML=\/gis\/openstreetmap-carto\/mapnik.xml/' /usr/local/etc/renderd.conf

# install LTS nodejs 8.x
RUN apt-get update && apt-get install -y apt-transport-https
RUN echo 'deb https://deb.nodesource.com/node_8.x xenial main' > /etc/apt/sources.list.d/nodesource.list
RUN echo 'deb-src https://deb.nodesource.com/node_8.x xenial main' >> /etc/apt/sources.list.d/nodesource.list
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN apt-get update && apt-get install -y nodejs

# configure mapnik to connect to remote postgres running in the postgis container
RUN sed -i 's/dbname: "gis"/dbname: "gis"\n    host: "postgis"\n    user: "gis"\n    password: "gis"/' /gis/openstreetmap-carto/project.mml

# generate osm stylesheet for mapnik
RUN npm install -g carto
RUN cd /gis/openstreetmap-carto && carto project.mml > mapnik.xml

RUN apt-get update && apt-get install -y postgresql-client

COPY ./docker/mapnik/entrypoint.sh /entrypoint.sh
