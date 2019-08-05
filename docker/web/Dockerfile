# Base image
FROM nginx

# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils

# Establish where Nginx should look for files
ENV RAILS_ROOT /var/www/dwallet

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Create log directory
RUN mkdir log

# Copy over static assets
COPY public public/

# Copy Nginx config template
COPY docker/web/nginx.conf /tmp/docker.nginx

# Substitute variable references in the Nginx config template for real values
# from the environment.
# Put the final config in its place.
RUN envsubst '$RAILS_ROOT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf

EXPOSE 80

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM
# (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
