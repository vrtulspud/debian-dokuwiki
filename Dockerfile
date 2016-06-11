FROM vrtulspud/debian-lighttpd-php:v1
MAINTAINER vrtulspud <email@domain.com>

#Sources
#https://hub.docker.com/r/mprasil/dokuwiki/~/dockerfile/
#https://hub.docker.com/r/sparklyballs/dokuwiki/~/dockerfile/
#https://hub.docker.com/r/vdemario/dokuwiki/~/dockerfile/

# Set the version of Dokuwiki
ENV DOKUWIKI_VERSION 2015-08-10a
ENV DOKUWIKI_CSUM a4b8ae00ce94e42d4ef52dd8f4ad30fe

ENV LAST_REFRESHED 6. September 2015

# Download & check & deploy dokuwiki & cleanup
RUN wget -q -O /dokuwiki.tgz \
	"http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    if [ "$DOKUWIKI_CSUM" != "$(md5sum /dokuwiki.tgz | awk '{print($1)}')" ];\
	then echo "Wrong md5sum of downloaded file!"; exit 1; fi && \
    mkdir /dokuwiki && \
    tar -zxf dokuwiki.tgz -C /dokuwiki --strip-components 1 && \
    rm dokuwiki.tgz && \
    mv /dokuwiki /var/www/html/dokuwiki

# Set up ownership
RUN chown -R www-data:www-data /var/www/html/dokuwiki

# Configure lighttpd
# ADD dokuwiki.conf /etc/lighttpd/conf-available/20-dokuwiki.conf
# RUN lighty-enable-mod dokuwiki accesslog
RUN mkdir /var/run/lighttpd && chown www-data.www-data /var/run/lighttpd

EXPOSE 80
VOLUME ["/var/www/html/dokuwiki/data/","/var/www/html/dokuwiki/lib/plugins/","/var/www/html/dokuwiki/conf/","/var/www/html/dokuwiki/lib/tpl/"]
#VOLUME ["/var/www/html/dokuwiki/data/","/var/www/html/dokuwiki/lib/plugins/","/var/www/html/dokuwiki/conf/","/var/www/html/dokuwiki/lib/tpl/","/var/log/"]

# start lighttpd
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

