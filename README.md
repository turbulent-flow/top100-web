# About this project
Top100 is a project that presents the top 100 categories in this world.

The explanation of the architecture can be found [here](https://github.com/LiamYabou/top100-scrapy/wiki/Architecture).

## Top100 Web
The top100-web is a client of the RPC. It uses the [cucumber](https://cucumber.io/docs/guides/overview/) as a test tool, which is based on the [BDD](https://cucumber.io/docs/bdd/) process.

# Devlopment
## Dependencies
- ruby 2.6.5
- rails 6.0.3
- rabbitmq 3.8

## Environment Variables
We use [direnv](https://direnv.net/) to streamline the loads of the env variables in the project.
```
export RACK_ENV=development
export CLOUDAMQP_URL=amqp://guest:guest@localhost:5672
export CLOUDFRONT_S3_ENDPOINT=
export CLOUDFRONT_ASSETS_ENDPOINT=
```

## Rails Server
You can run the following command to launch the web server.
```
rails s
```

## Testing
```
cucumber
```

# Contributing
If you have any suggestions or any issues you discovered, you can contact me via hello@mengliu.dev or commit a new `pull request`. I appreciate your help!
