FROM nginx

RUN mkdir /app

COPY src/index.html /app

COPY config/*.conf /etc/nginx

CMD nginx -c /etc/nginx/default.conf
