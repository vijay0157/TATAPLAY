FROM php:8.1-apache

# Copy all files to Apache web root
COPY . /var/www/html/

# Create data directory and set full read/write permissions
RUN mkdir -p /var/www/html/app/data && chmod -R 777 /var/www/html/app

# Enable Apache rewrite module for .htaccess files
RUN a2enmod rewrite

# Configure Apache to listen to the dynamic port provided by Render ($PORT)
RUN sed -i 's/80/${PORT}/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Expose port 80 (Render will route traffic automatically)
EXPOSE 80
