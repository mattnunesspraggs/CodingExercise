# CodingExercise Server

This is a very quick-and-dirty Ruby web service to provide a backend to the CodingExercise apps.

## V1.0 API Documentation

The V1.0 API provides a single endpoint, `/1.0/search`, which takes a single query parameter, "`query`", which specifies the search query.

The response object contains two fields: `ok` and `users`. `ok` will be `true` if the query generated at least one match, and `false` otherwise. The `users` field contains an array of objects representing the matched users.

**N.B.** This commands below uses the [`jq`](https://stedolan.github.io/jq/) utility to pretty-print the JSON result, but it's not necessary beyond that.

Matched user:
```
$ curl localhost:8080/1.0/search\?query=denys | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   561  100   561    0     0   109k      0 --:--:-- --:--:-- --:--:--  109k
{
  "ok": true,
  "users": [
    {
      "id": 152,
      "name": {
        "title": "Mrs",
        "first": "Charlie",
        "last": "Denys"
      },
      "username": "cdenys",
      "location": {
        "street": "339, Charles St",
        "city": "Springfield",
        "state": "Québec",
        "country": "Canada",
        "postcode": "T5U 0G3",
        "tz_offset": "+10:00"
      },
      "email": "charlie.denys@example.com",
      "phone": {
        "home": "224-996-5481",
        "cell": "245-122-9012"
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/women/42.jpg",
        "medium": "https://randomuser.me/api/portraits/med/women/42.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/women/42.jpg"
      },
      "nationality": "CA"
    }
  ]
}
```

No matched users:
```
$ curl localhost:8080/1.0/search\?query=foobar | jq 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    23  100    23    0     0   5750      0 --:--:-- --:--:-- --:--:--  5750
{
  "ok": false,
  "users": []
}
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