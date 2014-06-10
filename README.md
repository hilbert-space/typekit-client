# Typekit Client [![Gem Version](https://badge.fury.io/rb/typekit-client.svg)](http://badge.fury.io/rb/typekit-client) [![Build Status](https://travis-ci.org/IvanUkhov/typekit-client.svg?branch=master)](https://travis-ci.org/IvanUkhov/typekit-client)
A Ruby library for accessing the [Typekit API](https://typekit.com/docs/api).

## Requirements
The minimal supported version of Ruby is `2.1`. The easiest way to install
Ruby is via [RVM](https://rvm.io/):
```bash
$ curl -sSL https://get.rvm.io | bash -s stable --ruby=2.1
```

## Installation
Add the following line to your `Gemfile`:
```ruby
gem 'typekit-client', require: 'typekit'
```

Then execute:
```bash
$ bundle
```

Alternatively, you can install the gem manually:
```bash
$ gem install typekit-client
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

`client` has five methods: `index`, `show`, `create`, `update`, and `delete`.
The signature of each method is `action(*path, parameters = {})`. The
arguments are as follows:
* `*path` refers to an arbitrary number of arguments needed to identify
  the endpoint of interest (a plenty of examples are given below);
* `parameters` is a hash of parameters (optional).

Before sending the actual request to the Typekit API, the library checks
whether the endpoint given by `*path` exists and, if it does, whether
the desired action (`index`, `show`, _etc._) is permitted. So, if you
receive an exception, check the [API reference](https://typekit.com/docs/api/).

Now, let us have a look at some typical use cases. For clarity, the code
below makes use of the following auxiliary function:
```ruby
def p(data)
  puts JSON.pretty_generate(data)
rescue JSON::GeneratorError
  puts data.inspect
end
```

### List all kits
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

## General Command-line Interface
There is a simple tool provided in order to demonstrate the usage of the
library and to give the ability to perform basic operations without writing
any code. The tool is called `typekit-client`, and it should get installed
along with the gem. Try running:
```
$ typekit-client -h
Usage: typekit-client [options] [command]

Required options:
    -t, --token TOKEN                Set the API token

Other options:
    -h, --help                       Show this message
```

Alternatively, you can install `typekit-client` in the `bin` directory of
your project using the following command:
```bash
$ bundle binstubs typekit-client
```

The tool has two modes: normal and interactive. If `command` is provided,
the tool executes only that particular command and terminates:
```
$ typekit-client -t $tk_token index kits
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
$ typekit-client -t $tk_token
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

## Publishing Command-line Interface
There is another utility with the sole purpose of publishing kits. The tool
is called `typekit-publisher`:

```
$ typekit-publisher -h
Usage: typekit-publisher [options]

Required options:
    -t, --token TOKEN                Set the API token

Other options:
    -h, --help                       Show this message
```

Using `typekit-publisher`, you can publish all your kits at once. Here is
an example:

```
$ typekit-publisher -t $tk_token
Which kit would you like to publish?
   1. bas4cfe
   2. sfh6bkj
   3. kof8zcn
   4. all
> 4
Publishing bas4cfe... Done.
Publishing sfh6bkj... Done.
Publishing kof8zcn... Done.
Bye.
$
```

## Contributing
1. Fork it ( https://github.com/IvanUkhov/typekit-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
