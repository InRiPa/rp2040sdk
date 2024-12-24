# rp2040sdk
Toolchain for rp2040SDK

Build Image:

`podman build -f Dockerfile -t rp2040sdk2 .`

Example calls:

`podman run -it -p 3000:3000 --rm -v "$(pwd)/ws2812b:/pico/project"  localhost/rp2040sdk2:latest`

`docker run -it -p 3000:3000 --rm -v "$(pwd)/ws2812b:/pico/project"  localhost/rp2040sdk2:latest`
