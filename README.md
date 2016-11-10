## Requirements

Yours local user should be a "sudoer" without a password

```
$ sudo usermod -aG sudo <username>
```

Then put `%sudo ALL=(ALL:ALL) NOPASSWD: ALL` to the end of `/etc/sudoers`

## Install project

```ruby
$ bundle install
```

## Install redis

We use Redis to store timestamp when config was updated last time

Install:
```ruby
sudo apt-get -y install redis-server
```

Run"
```ruby
sudo service redis-server
```

## Start server

```ruby
$ bundle exec rackup
```

## Run rspec

```ruby
$ bundle exec rspec
```

## Basic usage

It's API tools, so we have several endpoints

Return timestamp when config for `:service` was last updated

```ruby
GET api/v1/:service/last_request
```

Receive json with updates for config. Updates config and reboot `:service`, also saves current time via timestamp into Redis.

```ruby
POST api/v1/:serive/config
```

Reboot `:service`

```ruby
PUT api/v1/:service/reboot
```

### Authentication:

We use jwt to authenticate users. Right now token hardcoded.
To get access to API add this header

```ruby
"Access-Token: eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJzdWNjZXNzIjp0cnVlfQ."
```

## Curl examples

```
curl -i  -X GET -H "Content-Type: application/json" -H "Access-Token: eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJzdWNjZXNzIjp0cnVlfQ." "localhost:9292/api/v1/services/nginx/last_request"
```

```
curl -i  -X POST -d '{"config": {"user": "www-data", "worker_processes": "10"}}' -H "Content-Type: application/json" -H "Access-Token: eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJzdWNjZXNzIjp0cnVlfQ." "localhost:9292/api/v1/services/nginx/config"
```

```
curl -i  -X POST -d "" -H "Content-Type: application/json" -H "Access-Token: eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJzdWNjZXNzIjp0cnVlfQ." "localhost:9292/api/v1/services/nginx/reboot"
```
