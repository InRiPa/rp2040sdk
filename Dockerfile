# docker run -it --rm --name rp2040sim -p 127.0.0.1:3000:3000 local/rp2040js:latest
# Use the official Node.js image from Docker Hub
FROM docker.io/library/node:18-alpine

# Set Path to PICO SDK
ENV PICO_SDK_PATH=/pico/pico-sdk

# Install libraries
RUN apk add --no-cache git cmake gcc-arm-none-eabi newlib-arm-none-eabi g++-arm-none-eabi && \
    apk add --no-cache --virtual build-dependencies build-base linux-headers bsd-compat-headers gcc wget curl python3 

# Container configuration
RUN echo "# Additional container config" >> /root/.profile && \
echo 'PS1="🐳\u@\H$:"' >> /root/.profile && \
echo 'alias ll="ls -lasih --color=auto"' >> /root/.profile

# Clone the RP2040 repository from GitHub
RUN mkdir /pico && cd /pico && \
    git clone https://github.com/raspberrypi/pico-sdk.git --branch master && \
    cd pico-sdk && git submodule update --init && \
    cd /pico && \
    git clone https://github.com/raspberrypi/pico-examples.git --branch master && \
    mkdir /pico/pico-examples/build && \
    cd /pico/pico-examples/build && \
    cmake /pico/pico-examples


# Clone the RP2040js repository from GitHub
RUN cd /pico && git clone https://github.com/wokwi/rp2040js.git /pico/rp2040js && \
    cd /pico/rp2040js && npm install
# Getting the hello_uart (2.0.0 bug - no hex file generated -> fix in 2.0.1)
RUN cd /pico/pico-examples/build/uart/hello_uart && make -j4 && \
    arm-none-eabi-objcopy -O ihex hello_uart.elf hello_uart.hex && \
    cp hello_uart.hex /pico/rp2040js/

# Expose the port that the emulator will run on (if applicable)
EXPOSE 3000

# Set the working directory inside the container
WORKDIR /pico/project

# Start the application
#CMD ["npm", "start"]
CMD ["sh"]


