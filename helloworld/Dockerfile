FROM nginx

RUN mkdir /app

COPY tmp/helloworld.tar.gz /app

RUN cd /app && \
tar xvzf helloworld.tar.gz

COPY config/*.conf /etc/nginx

CMD nginx -c /etc/nginx/default.conf
