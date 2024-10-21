# # Use the official WordPress image as a base
# FROM wordpress:latest

# # Set the working directory
# WORKDIR /var/www/html

# # Copy the WordPress source code into the container
# COPY ./src /var/www/html

# # Set ownership and permissions
# RUN chown -R www-data:www-data /var/www/html && \
#     chmod -R 755 /var/www/html

# # Expose port 80
# EXPOSE 80

# # Start the Apache server
# CMD ["apache2-foreground"]



# Use the official WordPress base image
FROM wordpress:latest


# Set the working directory
WORKDIR /var/www/html

# Copy the WordPress source code into the container
COPY ./src /var/www/html

# Set ownership and permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html


# Copy custom wp-config.php file to the container
COPY wp-config.php /var/www/html/wp-config.php

# Optional: Install any additional PHP extensions or tools if needed
# RUN apt-get update && apt-get install -y \
#     some-package

# Set permissions if needed
# RUN chown -R www-data:www-data /var/www/html/wp-content

# Expose port 80
EXPOSE 80
