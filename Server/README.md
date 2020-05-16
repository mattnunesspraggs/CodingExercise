# CodingExercise Server

This is a very quick-and-dirty Ruby web service to provide a backend to the CodingExercise apps.

## V1.0 API Documentation

The V1.0 API provides three endpoints:
- `/1.0/users/search`, which takes a single query parameter, "`query`", which specifies the search query;
- `/1.0/users/:id`, which takes a single parameter "`id`", which is the user's id; and
- `/1.0/users/:id/pictures/:size`, which takes a parameter "`id`", which is the user's id, and a parameter "`size`", which is one of ["`large`", "`medium`", "`thumbnail`"] and specifies the size of the image to be returned.

### `/1.0/users/search`

The response object contains two fields: `ok` and `users`. `ok` will be `true` if the query generated at least one match, and `false` otherwise. The `users` field contains an array of objects representing the matched users.

**N.B.** This commands below uses the [`jq`](https://stedolan.github.io/jq/) utility to pretty-print the JSON result, but it's not necessary beyond that.

Matched user:
```
$ curl localhost:8080/1.0/users/search\?query=denn | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   619  100   619    0     0   120k      0 --:--:-- --:--:-- --:--:--  120k
{
  "ok": true,
  "users": [
    {
      "id": "0d51423a-8a62-4e4f-8d72-09baca8031fd",
      "name": {
        "title": "Mr",
        "first": "Dennis",
        "last": "Jennings"
      },
      "username": "djennings",
      "location": {
        "street": "8077 W Sherman Dr",
        "city": "The Colony",
        "state": "Pennsylvania",
        "country": "United States",
        "postcode": "53598",
        "tz_offset": "+5:45"
      },
      "email": "dennis.jennings@example.com",
      "phone_numbers": {
        "home": "(729)-224-3922",
        "cell": "(420)-216-6176"
      },
      "nationality": "US"
    }
  ]
}
```

No matched users:
```
$ curl localhost:8080/1.0/users/search\?query=foobar | jq 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    23  100    23    0     0   5750      0 --:--:-- --:--:-- --:--:--  5750
{
  "ok": false,
  "users": []
}
```

`/1.0/users/:id`

```
$ curl localhost:8080/1.0/users/0d51423a-8a62-4e4f-8d72-09baca8031fd | jq 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   398  100   398    0     0  99500      0 --:--:-- --:--:-- --:--:-- 99500
{
  "id": "0d51423a-8a62-4e4f-8d72-09baca8031fd",
  "name": {
    "title": "Mr",
    "first": "Dennis",
    "last": "Jennings"
  },
  "username": "djennings",
  "location": {
    "street": "8077 W Sherman Dr",
    "city": "The Colony",
    "state": "Pennsylvania",
    "country": "United States",
    "postcode": "53598",
    "tz_offset": "+5:45"
  },
  "email": "dennis.jennings@example.com",
  "phone_numbers": {
    "home": "(729)-224-3922",
    "cell": "(420)-216-6176"
  },
  "nationality": "US"
}
```

### `/1.0/users/:id/pictures/:size`

**N.B.** This endpoint actually returns a redirect, so be sure to enable your client to follow redirects, or else you'll be stuck with `3xx` responses.

_Without Following Redirect:_
```
$ curl -v localhost:8080/1.0/users/0d51423a-8a62-4e4f-8d72-09baca8031fd/pictures/thumbnail
*   Trying ::1:8080...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
> GET /1.0/users/0d51423a-8a62-4e4f-8d72-09baca8031fd/pictures/thumbnail HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.65.1
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 302 Found 
< Content-Type: text/html;charset=utf-8
< Location: https://randomuser.me/api/portraits/thumb/men/66.jpg
< Content-Length: 0
< X-Xss-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-Frame-Options: SAMEORIGIN
< Server: WEBrick/1.4.2 (Ruby/2.6.3/2019-04-16)
< Date: Sat, 16 May 2020 01:47:29 GMT
< Connection: Keep-Alive
< 
* Connection #0 to host localhost left intact
```

## RDoc

You can generate [RDoc](https://github.com/ruby/rdoc) documentation for the server's classes:

```
$ bundle install    # if you haven't already
$ bundle exec rdoc
```

Which will create a `doc` directory containing the documentation.

## Heroku

This server is hosted on [Heroku](https://heroku.com) at [https://afternoon-journey-04115.herokuapp.com/](https://afternoon-journey-04115.herokuapp.com/):

```
$ curl https://afternoon-journey-04115.herokuapp.com/1.0/search\?query=s
```

## Deploying to Heroku

Since the server lives in a subdirectory of the main git repository, there's a hoop to jump to in order to deploy this to Heroku:

```
$ git subtree push --prefix Server heroku master
```

## How to run it locally

Firstly, you need a Ruby interpreter. I cannot recommend the one that ships with macOS - you should install a more current version using [RVM](https://rvm.io).

Next, you need the [`bundler` gem](https://bundler.io/docs.html):

```
$ gem install bundler
```

Once that completes, you need to install the server's dependencies:

```
$ bundle install
```

And finally, you can run the app:

```
$ bundle exec rackup -p 8080 config.ru
```

(Feel free to substitute whatever port you want - 8080 is just my favorite.)

Don't forget that you'll need to change CodingExercise/SlackAPI/SlackAPIService.swift to point at your local instance, and you'll need to add the following to the app's Info.plist in order to allow insecure HTTP requests to local endpoints:

```
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsLocalNetworking</key>
	<true/>
</dict>
```

## Other details

The server's data source is actually an in-memory cache of objects (rather than a database, for expediency), found in /Data/users.yaml. You can (re)generate this file with the `create-users.rb` script in the `Scripts` directory by running this command from the `Server` directory:

```
$ ruby Scripts/create-users.rb > Data/users.yaml
```

This script uses the [https://randomuser.me](https://randomuser.me) API to generate a number of random users (defined in the script), maps them to `User` objects (see: Models/User.rb), and prints the YAML serialization of those objects to stdout.

## Wait, you can do [Ruby](https://www.ruby-lang.org/en/) too?

Yep! Well, kind of. The advanced work I did in support of my Computer Science degree [is a Rails app](https://github.com/mattnunes/curriculum-planner-rails), but that was back in 2011. Nevertheless, Ruby is still my scripting language of choice.