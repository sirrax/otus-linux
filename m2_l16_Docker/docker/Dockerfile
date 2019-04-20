FROM alpine:3.9

LABEL maintainer="sirrax alpine-nginx <pol_mtg@mail.ru>"

RUN  apk update
RUN apk add nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]  