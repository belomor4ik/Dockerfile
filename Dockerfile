FROM debian:9 as build

RUN apt update && apt install -y vim wget curl procps gcc libpcre3 libpcre3-dev zlib1g-dev make git
RUN wget http://nginx.org/download/nginx-1.19.6.tar.gz && tar xvfz nginx-1.19.6.tar.gz && cd nginx-1.19.6 && ./configure && ls && make && make install
RUN cd && wget https://github.com/openresty/luajit2/archive/v2.1-20201027.tar.gz && tar xvfz v2.1-20201027.tar.gz && cd luajit2-2.1-20201027 && make insta$

FROM debian:9
WORKDIR /usr/local/nginx/html
COPY --from=build /usr/local/nginx/html .
WORKDIR /usr/local/nginx/conf
COPY --from=build /usr/local/nginx/conf .
WORKDIR /usr/local/nginx/sbin/
COPY --from=build /usr/local/nginx/sbin/nginx .
RUN mkdir ../logs && touch ../logs/error.log && chmod +x nginx
CMD ["./nginx", "-g", "daemon off;"]
