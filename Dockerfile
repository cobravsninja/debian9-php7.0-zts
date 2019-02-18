FROM debian:9

ENV dir /data

RUN mkdir $dir && echo deb-src `head -1 /etc/apt/sources.list | awk '{$1="";print}'` >> /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && apt-get -y install shtool devscripts dpkg-dev && \
  apt-get -y build-dep php7.0 && cd $dir && apt-get source php7.0 php-common php-pear && \
  cd php7.0-* && echo 'php7.0-zts (7.0.34-0+deb9u1) stretch; urgency=high\
  * zts\
\
 -- asdasd <asdads@asdasd.net>  Sat, 07 Dec 2058 11:36:49 +0000\
' | cat - debian/changelog > /tmp/changelog && mv /tmp/changelog debian/changelog && \
  sed -i '1s/php7\.0/php7\.0-zts/' debian/control && \
  DEB_BUILD_OPTIONS=nocheck debuild -us -uc -b && \
  cd $dir/php-defaults-* && DEB_BUILD_OPTIONS=nocheck debuild -us -uc -b && \
  cd $dir && echo "installing dependencies for pear building" && \
  dpkg -i php-common_*.deb php7.0-zts-cli_*.deb php7.0-zts-common_*.deb php7.0-zts-json_*.deb \
  php7.0-zts-opcache_*.deb php7.0-zts-readline_*.deb php7.0-zts-xml_*.deb && \
  cd $dir/php-pear-* && DEB_BUILD_OPTIONS=nocheck debuild -us -uc -b
