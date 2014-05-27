# Typekit
A Ruby library for accessing the [Typekit API](https://typekit.com/docs/api).

## Installation
`Ruby >= 2.1` is required. Make sure you have it installed:
``` bash
$ ruby -v
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin13.0]
```

In case you don’t:
``` bash
$ curl -sSL https://get.rvm.io | bash
$ rvm install 2.1
```

Add the gem into your `Gemfile` and run `bundler`:
``` bash
$ echo "gem 'typekit'" >> Gemfile
$ bundle
```

In order to interact with the Typekit API, one should have a valid API token.
You can generate such a token [here](https://typekit.com/account/tokens).
For convenience, let us create a shortcut for it:
``` bash
$ export tk_token=<YOUR_TOKEN_GOES_HERE>
```

## Usage
Here is the basic setup in a Ruby script:
``` ruby
require 'typekit'

client = Typekit::Client.new(token: ENV['tk_token'])
```

Let us now go through some typical use cases. For clarity, the code below
makes use of the following function:
``` ruby
def p(data)
  puts JSON.pretty_generate(data)
end
```

### Show all kits
Command:
``` ruby
p client.index(:kits)
```

Output:
```
{
  "kits": [
    {
      "id": "bas4cfe",
      "link": "/api/v1/json/kits/bas4cfe"
    },
    ...
  ]
}
```

### Show the description of a variant of a font family
Command:
``` ruby
p client.show(%w{families vcsm i9})
```

Output:
```
{
  "variation": {
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
}
```

### Show the font families in the trial library with pagination
Command:
``` ruby
p client.show(%w{libraries trial}, page: 10, per_page: 5)
```

Output:
```
{
  "library": {
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
}
```

### Create a new kit
Command:
``` ruby
p result = client.create(:kits, name: "Megakit", domains: "localhost")
kit_id = result['kit']['id']
```

Output:
```
{
  "kit": {
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
}
```

### Disable the badge of a kit
Command:
``` ruby
p client.update([ :kits, kit_id ], badge: false)
```

Output:
```
{
  "kit": {
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
}
```

### Look up the id of Proxima Nova by its slug
Command:
``` ruby
p result = client.show([ :families, 'proxima-nova' ])
family_id = result['family']['id']
```

Output:
```
{
  "family": {
    "id": "vcsm",
    "link": "/api/v1/json/families/vcsm"
  }
}
```

### Add Proxima Nova into a kit
Command:
``` ruby
p result = client.update([ :kits, kit_id ],
  families: { "0" => { id: family_id } })
```

Output:
```
{
  "kit": {
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
}
```

### Delete a kit
``` ruby
p client.delete([ :kits, kit_id ])
```

Output:
```
{
  "ok": true
}
```

## Command-line Interface (CLI)
There is a simple CLI provided in order to demonstrate the usage of the
library and to give the ability to perform basic operations without writing
any code. The following command will install the CLI in the `bin` directory
of your project:
``` bash
$ bundle binstubs typekit
```

Now:
```
$ ./bin/typekit -h
Usage: typekit [options] [command]

Required options:
    -t, --token TOKEN                Set the API token

Other options:
    -v, --version VERSION            Set the API version
    -f, --format FORMAT              Set the data format
    -h, --help                       Show this message
```

The tool has two modes: normal and interactive. If `command` is provided,
the tool executes only that particular command and terminates:
```
$ ./bin/typekit -t $tk_token index kits
{
  "kits": [
    {
      "id": "bas4cfe",
      "link": "/api/v1/json/kits/bas4cfe"
    },
    ...
  ]
}
$
```

If `command` is not provided, the tool gives a command prompt wherein one
can enter multiple commands:
```
$ ./bin/typekit -t $tk_token
Type 'help' for help and 'exit' to exit.
> help
Usage: <action> <resource> [parameters]

    <action>        index, show, create, update, or delete
    <resource>      a list separated by white spaces
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
{
  "kits": [
    {
      "id": "bas4cfe",
      "link": "/api/v1/json/kits/bas4cfe"
    },
    ...
  ]
}
> exit
Bye.
$
```

## Contributing

1. Fork it ( https://github.com/IvanUkhov/typekit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
