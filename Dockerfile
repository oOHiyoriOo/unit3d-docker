FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP and dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common git unzip bash locales tzdata php-cli php-zip php-mbstring php-xml php-curl sudo && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8

# Allow passwordless sudo for all users
RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd && chmod 0440 /etc/sudoers.d/nopasswd

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Add the PPA before installing libpng12
RUN add-apt-repository ppa:linuxuprising/libpng12 && \
    apt-get update && \
    apt-get install -y libpng12-0 apt-utils

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /app

RUN git clone https://github.com/poppabear8883/UNIT3D-INSTALLER.git .

# Install PHP dependencies
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# Make sure scripts are executable
RUN chmod +x ubuntu.sh

CMD ["tail", "-f", "/dev/null"]