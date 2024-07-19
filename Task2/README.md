# Nginx

Nginx is a high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server. It was initially created to solve the C10k problem, which refers to the difficulty traditional web servers had in handling more than ten thousand simultaneous connections. Nginx is known for its stability, rich feature set, simple configuration, and low resource consumption.

## Table of Contents
- [Nginx](#nginx)
  - [Table of Contents](#table-of-contents)
  - [Key Features and Use Cases](#key-features-and-use-cases)
  - [Configuration Files](#configuration-files)
    - [Main Configuration File (nginx.conf)](#main-configuration-file-nginxconf)
    - [Including Multiple Configuration Files](#including-multiple-configuration-files)
    - [Site-Specific Configuration Files](#site-specific-configuration-files)
  - [Using Variables](#using-variables)
  - [Advanced Configuration](#advanced-configuration)
    - [Rate Limiting Example](#rate-limiting-example)
  - [Monitoring and Logging](#monitoring-and-logging)
    - [Access and Error Logs](#access-and-error-logs)
  - [Additional Resources](#additional-resources)
   
## Key Features and Use Cases

1. **HTTP Server**
   Serving static content, handling HTTP requests, managing concurrent connections.
   ```bash
    server {
        # Start configuration for a virtual server.

        listen 80; # listens on port 80

        server_name example.com;
        # Domain name for this server block. Route requests based on the host header in the HTTP request.

        location / {
            # Location block. Applies to all requests to the root URL ("/").

            root /var/www/html;
            # Specifies the root directory for the requested files.

            index index.html index.htm;
            # Specifies the files to look for when a directory is requested. It will look for index.html first, and if not found, it will look for index.htm.
        }
    }
   ```

2. **Reverse Proxy**
   Forwarding client requests to backend servers, load balancing, caching, SSL termination.
   ```bash
    server {
        listen 80;  
        server_name example.com;

        location / {
            proxy_pass http://backend_server;  # Forward requests to the backend server

            proxy_set_header Host $host;  # Set the Host header to the original request's host

            proxy_set_header X-Real-IP $remote_addr;  # Set the header to the client's real IP address

            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  # Preserve the original client's IP address

        }
    }
   ```

3. **Load Balancing**
   Nginx supports several load balancing methods:
   - **Round Robin (Default)**: Requests are distributed evenly across all servers.
   ```bash
    http {
        upstream backend {
            server backend1.example.com;  # Backend server 1
            server backend2.example.com;  # Backend server 2
            server backend3.example.com;  # Backend server 3
        }

        server {
            listen 80;
            server_name example.com;

            location / {
                proxy_pass http://backend;  # Forward requests to the backend upstream
            }
        }
    }
   ```
  
  - **Least Connections**: Requests are sent to the server with the fewest active connections.
   ```bash
    http {
        upstream backend {
            least_conn;  # Use least connections load balancing method
            server backend1.example.com;  
            server backend2.example.com;  
            server backend3.example.com; 
        }

        server {
            listen 80;
            server_name example.com;

            location / {
                proxy_pass http://backend;
            }
        }
    }
   ```

  - **IP Hash**: Requests from the same client IP are consistently sent to the same server.
   ```bash
    http {
        upstream backend {
            ip_hash;  # Use IP hash load balancing method
            server backend1.example.com;  
            server backend2.example.com;  
            server backend3.example.com;  
        }

        server {
            listen 80;  
            server_name example.com;

            location / {
                proxy_pass http://backend;
            }
        }
    }
   ```

4. **SSL/TLS Termination**
   Offloading SSL/TLS decryption from backend servers to improve performance.
   ```bash
    server {
        listen 443 ssl;  # Listen on port 443 for SSL/TLS traffic
        server_name example.com;

        ssl_certificate /etc/nginx/ssl/nginx.crt;  # Path to SSL certificate
        ssl_certificate_key /etc/nginx/ssl/nginx.key;  # Path to SSL certificate key

        location / {
            proxy_pass http://backend_server;  # Forward requests to the backend server
        }
    }
   ```

5. **Caching**
   Improving performance by caching responses from backend servers.
   ```bash
    http {
        proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=my_cache:10m max_size=10g inactive=60m use_temp_path=off;  # Define cache path and parameters

        server {
            listen 80;
            server_name example.com;

            location / {
                proxy_cache my_cache;  # Use defined cache
                proxy_pass http://backend_server;
            }
        }
    }
   ```

6. **WebSocket Proxying**
   Proxying WebSocket connections is useful when you have a backend server handling real-time communication, such as chat applications, live notifications, or gaming. WebSockets provide a full-duplex communication channel over a single TCP connection, enabling low-latency, real-time interactions.
   ```bash
    http {
        server {
            listen 80;
            server_name example.com;

            location /ws {
                proxy_pass http://backend_server;  # Forward WebSocket requests to the backend server

                proxy_http_version 1.1;  # Use HTTP/1.1 for WebSocket support

                proxy_set_header Upgrade $http_upgrade;  # Set header for WebSocket upgrade

                proxy_set_header Connection "upgrade";  # Set header to maintain the connection upgrade
            }
        }
    }
   ```

7. **Serving Dynamic Content**
   Handling dynamic content involves serving dynamic web pages or responses generated by backend applications. Common scenarios include:
   - Using PHP for web applications (e.g., WordPress, Laravel).
   - Using Python with frameworks like Django or Flask.
   - Using any other language or framework that generates content dynamically.
   - Nginx can proxy requests to these backend applications or use modules like FastCGI, SCGI, or uWSGI to interact with them.
   ```bash
    server {
        listen 80;
        server_name example.com;

        location / {
            root /var/www/html;  # Document root
            index index.php index.html index.htm;  # Index files to look for
        }

        location ~ \.php$ {
            include fastcgi_params;  # Include FastCGI parameters
            fastcgi_pass unix:/run/php/php7.4-fpm.sock;  # Path to the PHP-FPM socket
            fastcgi_index index.php;  # Default file to serve when a directory is requested
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  # Path to the script to execute
        }
    }
   ```

8. **URL Rewriting and Redirects**
    Nginx provides powerful mechanisms for URL rewriting and redirects using the rewrite and return directives.

    ### Example of URL Rewriting:
    ```bash
        server {
            listen 80;
            server_name example.com;

            location /oldpath/ {
                rewrite ^/oldpath/(.*)$ /newpath/$1 permanent;
                # This directive rewrites URLs from /oldpath/ to /newpath/ and issues a permanent (301) redirect.
            }

            location /newpath/ {
                proxy_pass http://backend_server;
            }
        }
    ```
    ### Example of URL Redirect:
    ```bash
        server {
            listen 80;
            server_name example.com;

            location / {
                return 301 https://$server_name$request_uri;
                # This directive redirects all HTTP requests to HTTPS.
            }
        }
    ```

9. **Security Enhancements**
    Nginx can be configured with various security enhancements to protect web applications and servers.
    ```bash
        server {
            listen 80;
            server_name example.com;

            location / {
                auth_basic "Restricted Area"; # Enables basic HTTP authentication.
                auth_basic_user_file /etc/nginx/.htpasswd; # Specifies the password file for authentication.
                proxy_pass http://backend_server;
            }
        }
    ```

10. **Custom Error Pages**
    You can configure custom error pages for different HTTP status codes to provide a better user experience.
    ```bash
        server {
            listen 80;
            server_name example.com;

            error_page 404 /custom_404.html; # Defines a custom error page for 404 errors.

            # Specifies the location of the custom error page.
            location = /custom_404.html {
                root /var/www/html;
            }

            location / {
                proxy_pass http://backend_server;
            }
        }
    ```

11. **Subdomain and Multi-Site Hosting**
    Nginx can handle multiple subdomains and host multiple websites on the same server.
    ```bash
        # Configuration for the first subdomain.
        server {
            listen 80;
            server_name site1.example.com;

            location / {
                proxy_pass http://backend_server1;
            }
        }

        # Configuration for the second subdomain.
        server {
            listen 80;
            server_name site2.example.com;

            location / {
                proxy_pass http://backend_server2;
            }
        }
    ```

## Configuration Files
Nginx configuration files are usually located in /etc/nginx on Linux systems. These files are often divided into multiple smaller files to enhance maintainability and modularity. This structure allows you to keep global settings separate from site-specific configurations.

### Main Configuration File (nginx.conf)
The main configuration file contains global settings and directives for Nginx. It can also include other configuration files to organize different parts of the configuration.
```bash
    user www-data;  # Set the user and group under which the Nginx worker processes will run
    worker_processes auto;  # Automatically determine the number of worker processes based on the number of available CPU cores
    pid /run/nginx.pid;  # Specify the file where the process ID of the master process will be stored
    include /etc/nginx/modules-enabled/*.conf;  # Include additional configuration files for Nginx modules

    events {
        worker_connections 768;  # Set the maximum number of simultaneous connections that can be handled by a worker process
    }

    http {
        include /etc/nginx/mime.types;  # Include MIME type definitions for different file types
        default_type application/octet-stream;  # Set the default MIME type to use if the file type is not recognized

        log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for"';  # Define the format for access log entries

        access_log /var/log/nginx/access.log main;  # Specify the path and format for the access log
        error_log /var/log/nginx/error.log warn;  # Specify the path and log level for the error log

        sendfile on;  # Enable sendfile() for efficient file transfers
        tcp_nopush on;  # Enable TCP_NOPUSH for improved network performance
        tcp_nodelay on;  # Enable TCP_NODELAY for real-time applications
        keepalive_timeout 65;  # Set the timeout for keep-alive connections
        types_hash_max_size 2048;  # Set the maximum size of the MIME types hash table

        include /etc/nginx/conf.d/*.conf;  # Include all configuration files from the conf.d directory
        include /etc/nginx/sites-enabled/*;  # Include all configuration files from the sites-enabled directory
    }
```

### Including Multiple Configuration Files
Nginx allows the inclusion of multiple configuration files using the include directive. This enhances modularity and organization by allowing you to split the configuration into smaller, more manageable files.
```bash
    http {
        include /etc/nginx/conf.d/*.conf;  # Include all configuration files from the conf.d directory
        include /etc/nginx/sites-enabled/*;  # Include all configuration files from the sites-enabled directory
    }
```

### Site-Specific Configuration Files
These files typically contain server blocks and are located in /etc/nginx/sites-available and /etc/nginx/sites-enabled. The sites-available directory holds all the configuration files for individual sites, while the sites-enabled directory holds symbolic links to the files in sites-available that should be active.

1. Create a new file in /etc/nginx/sites-available (e.g., example.com):
```bash
    server {
        listen 80;  # Listen on port 80
        server_name example.com www.example.com;  # Server domain names

        root /var/www/example.com;  # Document root
        index index.html index.htm;  # Index files

        location / {
            try_files $uri $uri/ =404;  # Try to serve the requested URI or return a 404 error
        }
    }
```

2. Enable the site by creating a symbolic link in /etc/nginx/sites-enabled:
```bash
    sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
```

## Using Variables
Nginx provides various variables that can be used to customize configurations. These variables can represent client-specific information, request details, or other dynamic values.
```bash
    server {
        listen 80;
        server_name example.com;

        location / {
            add_header X-Request-ID $request_id;  # Add a custom header with the request ID
            proxy_pass http://backend_server;  # Forward requests to the backend server
        }
    }
```

## Advanced Configuration
Nginx supports advanced features like rate limiting, connection limiting, and request buffering. These features can help you control and manage traffic to your servers effectively.

### Rate Limiting Example
Rate limiting is used to control the number of requests a client can make in a specified period. This helps prevent abuse and ensures fair resource usage.
```bash
    http {
        limit_req_zone $binary_remote_addr zone=mylimit:10m rate=1r/s;  # Define a rate limit zone with a rate of 1 request per second

        server {
            listen 80;  # Listen on port 80
            server_name example.com;  # Server domain name

            location / {
                limit_req zone=mylimit burst=5;  # Apply rate limiting with a burst allowance of 5 requests
                proxy_pass http://backend_server;  # Forward requests to the backend server
            }
        }
    }
```

## Monitoring and Logging
Nginx provides extensive logging capabilities to monitor and troubleshoot web traffic. You can customize log formats and specify different log files for access and error logs.

### Access and Error Logs
Access logs record detailed information about client requests, while error logs record errors and issues encountered during request processing.
```bash
    http {
        log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for"';  # Define the format for access log entries

        access_log /var/log/nginx/access.log main;  # Specify the path and format for the access log
        error_log /var/log/nginx/error.log warn;  # Specify the path and log level for the error log
    }
```

## Additional Resources
- [Nginx Documentation](https://nginx.org/en/docs/)
- [The Nginx Handbook - FreeCodeCamp](https://www.freecodecamp.org/news/the-nginx-handbook/)
- [The Ultimate Starter’s Guide to Nginx - Medium](https://medium.com/@ericfflynn/the-ultimate-starters-guide-to-nginx-7aa8489e460e)
- [How to install and setup NGINX in Windows [2024] - YouTube](https://www.youtube.com/watch?v=9t9Mp0BGnyI)
- [Nginx Tutorial for Beginners - YouTube](https://www.youtube.com/watch?v=4539ULMhY_I)
