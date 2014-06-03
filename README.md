# Typekit Client [![Gem Version](https://badge.fury.io/rb/typekit-client.svg)](http://badge.fury.io/rb/typekit-client) [![Build Status](https://travis-ci.org/IvanUkhov/typekit-client.svg?branch=master)](https://travis-ci.org/IvanUkhov/typekit-client)
A Ruby library for accessing the [Typekit API](https://typekit.com/docs/api).

## Installation
`Ruby >= 2.1` is required. Make sure you have it installed:
```bash
$ ruby -v
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin13.0]
```

In case you don’t:
```bash
$ curl -sSL https://get.rvm.io | bash
$ rvm install 2.1
```

Add the gem into your `Gemfile`:
```ruby
gem 'typekit-client', require: 'typekit'
```

Then run `bundler`:
```bash
$ bundle
```

In order to interact with the Typekit API, one should have a valid API token.
You can generate such a token [here](https://typekit.com/account/tokens).
For convenience, let us create a shortcut for it:
```bash
$ export tk_token=YOUR_TOKEN_GOES_HERE
```

## Usage
Here is the basic setup in a Ruby script:
```ruby
require 'typekit'

client = Typekit::Client.new(token: ENV['tk_token'])
```

And here is how to run it, assuming you name your script `app.rb`:
```bash
$ bundle exec ruby app.rb
```

The main method of `client` is `perform(action, *path, parameters = {})`.
The arguments are as follows:
* `action` is the action that you would like to perform on a resource, and
  it can be one of `:index`, `:show`, `:create`, `:update`, or `:delete`;
* `*path` refers to an arbitrary number of arguments needed to identify
  the desired resource (a plenty of examples are given below), and it
  always begins with one of `:families`, `:kits`, or `:libraries`;
* `parameters` is a hash of parameters needed to perform the action.

`perform` has an alias for each of the actions: `index(*path, parameters = {})`,
`show(*path, parameters = {})`, `create(*path, parameters = {})`, and so on.
Before sending the actual request to the Typekit API, `perform` checks
whether the resource given by `*path` makes sense and, if it does, whether
`action` can be performed on that resource. So, if you receive an exception,
check the [API reference](https://typekit.com/docs/api/).

Now, let us have a look at some typical use cases. For clarity, the code
below makes use of the following auxiliary function:
```ruby
def p(data)
  puts JSON.pretty_generate(data)
rescue JSON::GeneratorError
  puts data.inspect
end
```

### Show all kits
Code:
```ruby
p kits = client.index(:kits)
p kits.map(&:class)
p kits.first.attributes
p kits.first.link
```

Output:
```json
[
  {
    "id": "bas4cfe",
    "link": "/api/v1/json/kits/bas4cfe"
  },
  {
    "id": "sfh6bkj",
    "link": "/api/v1/json/kits/sfh6bkj"
  },
  {
    "id": "kof8zcn",
    "link": "/api/v1/json/kits/kof8zcn"
  }
]
[
  "Typekit::Record::Kit",
  "Typekit::Record::Kit",
  "Typekit::Record::Kit"
]
{
  "id": "bas4cfe",
  "link": "/api/v1/json/kits/bas4cfe"
}
"/api/v1/json/kits/bas4cfe"
```

### Show the description of a variation of a font family
Code:
```ruby
p client.show(:families, 'vcsm', 'i9')
```

Output:
```json
{
  "id": "vcsm:i9",
  "name": "Proxima Nova Black Italic",
  "family": {
    "id": "vcsm",
    "link": "/api/v1/json/families/vcsm",
    "name": "Proxima Nova"
  },
  "font_style": "italic",
  "font_variant": "normal",
  "font_weight": "900",
  ...
}
```

### Show the font families in the trial library with pagination
Code:
```ruby
p client.show(:libraries, 'trial', page: 10, per_page: 5)
```

Output:
```json
{
  "id": "trial",
  "link": "/api/v1/json/libraries/trial",
  "name": "Trial Library",
  "families": [
    {
      "id": "qnhl",
      "link": "/api/v1/json/families/qnhl",
      "name": "Caliban Std"
    },
    {
      "id": "vybr",
      "link": "/api/v1/json/families/vybr",
      "name": "Calluna"
    },
    ...
  ],
  "pagination": {
    "count": 261,
    "on": "families",
    "page": 10,
    "page_count": 53,
    "per_page": 5
  }
}
```

### Create a new kit
Code:
```ruby
p kit = client.create(:kits, name: 'Megakit', domains: 'localhost')
```

Output:
```json
{
  "id": "izw0qiq",
  "name": "Megakit",
  "analytics": false,
  "badge": true,
  "domains": [
    "localhost"
  ],
  "families": [

  ]
}
```

### Disable the badge of a kit
Code:
```ruby
p client.update(:kits, kit.id, badge: false)
```

Output:
```json
{
  "id": "izw0qiq",
  "name": "Megakit",
  "analytics": false,
  "badge": false,
  "domains": [
    "localhost"
  ],
  "families": [

  ]
}
```

### Look up the id of a font family by its slug
Code:
```ruby
p family = client.show(:families, 'proxima-nova')
```

Output:
```json
{
  "id": "vcsm",
  "link": "/api/v1/json/families/vcsm"
}
```

### Add a font family into a kit
Code:
```ruby
p client.update(:kits, kit.id, families: { "0" => { id: family.id } })
```

Output:
```json
{
  "id": "nys8sny",
  "name": "Megakit",
  "analytics": false,
  "badge": false,
  "domains": [
    "localhost"
  ],
  "families": [
    {
      "id": "vcsm",
      "name": "Proxima Nova",
      "slug": "proxima-nova",
      "css_names": [
        "proxima-nova-1",
        "proxima-nova-2"
      ],
      ...
    }
  ]
}
```

### Publish a kit
Code:
```ruby
p client.update(:kits, kit.id, :publish)
```

Output:
```
#<DateTime: 2014-05-31T06:45:29+00:00 ((2456809j,24329s,0n),+0s,2299161j)>
```

### Show the description of a published kit
Code:
```ruby
p client.show(:kits, kit.id, :published)
```

Output:
```json
{
  "id": "vzt4lrg",
  "name": "Megakit",
  "analytics": false,
  "badge": false,
  "domains": [
    "localhost"
  ],
  "families": [
    ...
  ],
  "published": "2014-05-31T06:45:29Z"
}
```

### Delete a kit
Command:
```ruby
p client.delete(:kits, kit.id)
```

Output:
```
true
```

## Command-line Interface (CLI)
There is a simple CLI provided in order to demonstrate the usage of the
library and to give the ability to perform basic operations without writing
any code. The tool is called `typekit`, and it should get installed along
with the gem. Try running:
```
$ typekit -h
Usage: typekit [options] [command]

Required options:
    -t, --token TOKEN                Set the API token

Other options:
    -h, --help                       Show this message
```

Alternatively, you can install `typekit` in the `bin` directory of your
project using the following command:
```bash
$ bundle binstubs typekit
```

The tool has two modes: normal and interactive. If `command` is provided,
the tool executes only that particular command and terminates:
```
$ typekit -t $tk_token index kits
[
  {
    "id": "bas4cfe",
    "link": "/api/v1/json/kits/bas4cfe"
  },
  ...
]
$
```

If `command` is not provided, the tool gives a command prompt wherein one
can enter multiple commands:
```
$ typekit -t $tk_token
Type 'help' for help and 'exit' to exit.
> help
Usage: <action> <resource> [parameters]

    <action>        index, show, create, update, or delete
    <resource>      a list separated by whitespaces
    [parameters]    a JSON-encoded hash (optional)

Examples:
    index kits
    show kits bas4cfe families vcsm
    show families vcsm i9
    show libraries trial { "page": 10, "per_page": 5 }
    create kits { "name": "Megakit", "domains": "localhost" }
    update kits bas4cfe { "name": "Ultrakit" }
    delete kits bas4cfe
> index kits
[
  {
    "id": "bas4cfe",
    "link": "/api/v1/json/kits/bas4cfe"
  },
  ...
]
> exit
Bye.
$
```

## Contributing
1. Fork it ( https://github.com/IvanUkhov/typekit-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
