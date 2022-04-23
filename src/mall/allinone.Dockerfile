FROM nginx:alpine
COPY ./build /app/
COPY mall-all.template /etc/nginx/conf.d/mall-all.template
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]