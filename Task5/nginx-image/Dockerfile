# Use the official Amazon Linux 2 image as the base image
FROM amazonlinux:2

# Install necessary packages, including amazon-efs-utils
RUN yum install -y amazon-efs-utils python3 && \
    yum clean all

# Copy a simple HTML file to the server directory
COPY index.html /var/www/html/index.html

# Set the working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# Start a simple Python HTTP server
CMD ["python3", "-m", "http.server", "80"]