# Typekit Client [![Gem Version](https://badge.fury.io/rb/typekit-client.svg)](http://badge.fury.io/rb/typekit-client) [![Dependency Status](https://gemnasium.com/IvanUkhov/typekit-client.svg)](https://gemnasium.com/IvanUkhov/typekit-client) [![Build Status](https://travis-ci.org/IvanUkhov/typekit-client.svg?branch=master)](https://travis-ci.org/IvanUkhov/typekit-client)

A Ruby library for accessing the [Typekit API](https://typekit.com/docs/api).

## Installation

In your `Gemfile`:

```ruby
gem 'typekit-client', require: 'typekit'
```

In your terminal:

```bash
$ bundle
```

## TL;DR

Here are some typical use cases of the gem:

```ruby
require 'typekit'

client = Typekit::Client.new(token: ENV['tk_token'])

# List all kits
kits = client::Kit.all

# Find a kit by id
kit = client::Kit.find('bas4cfe')

# Create a kit
kit = client::Kit.create(name: 'Megakit', domains: ['localhost'],
  families: [{ id: 'vcsm', subset: 'all', variations: ['n4'] }])

# Update a kit
kit.update(name: 'Ultrakit', families: [{ id: 'vybr' }])

# Publish a kit
kit.publish

# Delete a kit
kit.delete

# Find a font family by id
family = client::Family.find('vybr')

# Find a font family by slug
family = client::Family.find('calluna')

# List all font libraries
libraries = client::Library.all

# Find a library by id and retrieve its first ten font families
library = client::Library.find('trial', page: 1, per_page: 10)
```

## Preliminaries

The Typekit API provides four major resources: kits, font families, font
variations, and font libraries. The operations concerning kits require
authentication. To this end, one has to have a valid API token. Such a token
can be generated on [Your API Tokens](https://typekit.com/account/tokens) on
Typekit. For convenience, the examples on this page assume that a valid API
token is stored in an environment variable called `tk_token`.

The four resources are mapped to the following Ruby classes, respectively:

* `Typekit::Record::Kit`,
* `Typekit::Record::Family`,
* `Typekit::Record::Variation`, and
* `Typekit::Record::Library`.

Each resource has its own set of permitted operations. The entire routing map
is as follows:

```ruby
resources :families, only: :show do
  show ':variation', on: :member
end

resources :kits do
  resources :families, only: [ :show, :update, :delete ]
  show :published, on: :member
  update :publish, on: :member
end

resources :libraries, only: [ :index, :show ]
```

Here, the DSL of [Apitizer](https://github.com/IvanUkhov/apitizer) is utilized,
which is similar to the one of
[Rails](http://guides.rubyonrails.org/routing.html).

Refer to the [official documentation](https://typekit.com/docs/api) of the
Typekit API to get a complete description of each endpoint.

## High-Level Programming Interface

The preferable way to work with the four Ruby classes given earlier is via
an instance of `Typekit::Client` as a module:

* `client::Kit`,
* `client::Family`,
* `client::Variation`, and
* `client::Library`.

The kits that are available under your account can be listed as follows:

```ruby
kits = client::Kit.all
```

Each kit is an instance of `Typekit::Record::Kit`, and it contains all
attributes that the Typekit API returns in response to the corresponding
API call. In the case of `all`, the Typekit API provides only two attribute,
namely, `id` and `link`; such kits will be referred to as incomplete.
Here is an example:

```ruby
kit.complete?
# => false

kit.attributes
# =>
# {
#   "id": "bas4cfe",
#   "link": "/api/v1/json/kits/bas4cfe"
# }

kit.id
# => "bas4cfe"

kit.link
# => "/api/v1/json/kits/bas4cfe"
```

A particular kit can be fetched using its `id`:

```ruby
kit = client::Kit.find('bas4cfe')
```

In the case of `find`, you get all information about the kit:

```ruby
kit.complete?
# => true

kit.attributes
# =>
# {
#   "id": "bas4cfe",
#   "name": "Megakit",
#   "analytics": false,
#   "domains": [
#     "localhost"
#   ],
#   "families": [
#     ...
#   ]
# }

kit.name
# => "Megakit"
```

In order to reload a kit and/or retrieve missing data, call `load`:

```ruby
kit.complete?
# => false

kit.load

kit.complete?
# => true
```

In order to change an attribute of a kit, assign a new value to that
attribute and call `save`:

```ruby
kit.name = 'Ultrakit'
kit.save
```

Similarly, the `families` attribute, containing the font families included in
the kit, can be changed as desired:

```ruby
# Push a new instance of Typekit::Record::Family
kit.families << Typekit::Record::Family.new(id: 'vybr')

# Push a hash of attributes
kit.families << { id: 'vcsm', subset: 'all' }

# Replace with an font family found via client
kit.families = [client::Family.find('droid-sans')]

# Remove all font families
kit.families = []

kit.save
```

If you want to browse the font families hosted on Typekit, you can do so via
libraries. All libraries can be listed as follows:

```ruby
libraries = client::Library.all
```

A particular library can be fetched using:

```ruby
library = client::Library.find('trial')
```

In this case, along with some general information about the library itself, the
Typekit API will return a subset of the font families included in the library
according to its default pagination. The desired pagination can be specified as
follows:

```ruby
library = client::Library.find('trial', page: 1, per_page: 10)
```

The font families are stored in the `families` attribute of the library.

## Low-Level Programming Interface

An instance of `Typekit::Client` has a method called `process` that can be
used to perform arbitrary API calls. The signature of the method is
`process(action, *enpoint, parameters = {})`, and the arguments are as follows:

* `action` is one of `:index`, `:show`, `:create`, `:update`, and `:delete`;
* `*endpoint` refers to an arbitrary number of arguments needed to identify
  the endpoint of interest;
* `parameters` is a optional hash of parameters.

Each of the five actions has a shortcut: instead of calling
`client.process(action, *endpoint, parameters)`, you can just call
`client.action(*endpoint, parameters)` replacing `action` with `index`, `show`,
`create`, `update`, or `delete`.

Here are some examples:

```ruby
require 'typekit'

client = Typekit::Client.new(token: ENV['tk_token'])

# List all kits
kits = client.index(:kits)

# Find a kit by id
kit = client.show(:kits, 'bas4cfe')

# Create a kit
kit = client.create(:kits, name: 'Megakit', domains: ['localhost'],
  families: [{ id: 'vcsm', subset: 'all', variations: ['n4'] }])

# Update a kit
client.update(:kits, 'bas4cfe', name: 'Ultrakit', families: [{ id: 'vybr' }])

# Publish a kit
client.update(:kits, 'bas4cfe', :publish)

# Delete a kit
client.delete(:kits, 'bas4cfe')

# Find a font family by id
family = client.show(:families, 'vybr')

# Find a font family by slug
family = client.show(:families, 'calluna')

# Show a font family in a kit by id
family = client.show(:kits, 'bas4cfe', :families, 'vcsm')

# Show a variation of a font family by id
variation = client.show(:families, 'vybr', 'i4')

# List all font libraries
libraries = client.index(:libraries)

# Find a library by id and retrieve its first ten font families
library = client.show(:libraries, 'trial', page: 1, per_page: 10)
```

## Low-Level Command-Line Interface

There is a command-line tool provided in order to interact with the Typekit
API without writing any code.  The tool is called `typekit-client`, and
its capabilities directly reflect the low-level programming interface describe
earlier:

```
$ typekit-client -h
Usage: typekit-client [options] [command]

Required options:
    -t, --token TOKEN                Set the API token

Other options:
    -h, --help                       Show this message
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
    <endpoint>      a list separated by whitespaces
    [parameters]    a JSON-encoded hash (optional)

Examples:
    index kits
    create kits { "name": "Megakit", domains: ["localhost"] }
    show kits bas4cfe
    update kits bas4cfe { families: [{ "id": "vybr" }] }
    update kits bas4cfe publish
    delete kits bas4cfe
    show families vybr i4
    show libraries trial { "page": 10, "per_page": 5 }
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

## Publishing Command-Line Interface

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

1. [Fork](https://help.github.com/articles/fork-a-repo) the project.
2. Create a branch for your feature (`git checkout -b awesome-feature`).
3. Implement your feature (`vim`).
4. Commit your changes (`git commit -am 'Implemented an awesome feature'`).
5. Push to the branch (`git push origin awesome-feature`).
6. [Create](https://help.github.com/articles/creating-a-pull-request)
   a new Pull Request.
