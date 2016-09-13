# croque
## What the hell ?
This server uses [docker-compose](https://docs.docker.com/compose/), which itself uses [docker](https://www.docker.com/).

Basically, you run an instance of the database, an instance of the api, an instance of the admin interface and an instance of the reverse proxy server [nginx](https://nginx.org/), all orchestrated by docker-compose. They are independent to each other AND to the platform they are running on. You won't have to install anything but docker on your machine !! See [here](https://docs.docker.com/compose/install/) to install.

## Ok, now what ?
First, get the files. You can clone the repo by firing up the terminal and executing:
```
git clone https://github.com/louismerlin/croque
```
This will create a **croque** directory, where the files live.

You can then go to **croque** (`cd croque`), and launch the server with:
```
docker-compose build
docker-compose up
```
Just hit `ctrl-c` when you are done (mabye `cmd-c` on mac, I have no idea) and the processes will kill themselves gracefully.

While the server is up, you will be able to see the admin interface at [localhost:8080](localhost:8080) and play with the api at [localhost:8081](localhost:8081). This is meant to be changed on the final server, where it will be burger.whatever.soy and api.whatever.soy.

## So... What happened ?
If you want to know more about docker-compose, see [here](https://docs.docker.com/compose/gettingstarted/). When you're done, try again and send me a message on **#back-end** !
