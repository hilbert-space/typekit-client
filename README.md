# Typekit
A Ruby library for accessing Typekit’s API.

## Installation

One way to play with the library is to install it as a gem:

```
$ echo "gem 'typekit', git: 'https://github.com/IvanUkhov/typekit'" >> Gemfile
$ bundle install
$ bundle binstubs typekit
```

Alternatively, one can directly clone the repository:

```
$ git clone https://github.com/IvanUkhov/typekit
$ cd typekit
```

## Usage

There is a simple application provided in order to illustrate the usage
of the library. The tool is called `typekit` and can be found in `bin`:

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

First of all, one has to have a valid API token, which can be generated
[here](https://typekit.com/account/tokens). For convenience, let us create
a shortcut for the token:

```
$ export tk_token=<YOUR_TOKEN_GOES_HERE>
```

The tool has two modes: normal and interactive. If `command` is provided,
the tool executes only that particular command and exits. Otherwise, it
gives a command prompt wherein one can enter multiple commands:

```
$ ./bin/typekit -t $tk_token
Type 'help' for help and 'exit' to exit.
> help
Usage: <action> <resource> [parameters]

    <action>        show, create, update, or delete
    <resource>      a list separated by white spaces
    [parameters]    a JSON-encoded hash (optional)

Examples:
    show kits
    show kits bas4cfe families vcsm
    show families vcsm i9
    show libraries trial { "page": 10, "per_page": 5 }
    create kits { "name": "Megakit", "domains": "localhost" }
    update kits bas4cfe { "name": "Ultrakit" }
    delete kits bas4cfe
> exit
Bye.
$
```

Now, let us go through some typical use cases.

### Show all kits
In the normal (single-command) mode:
```
$ ./bin/typekit -t $tk_token show kits
{
  "kits": [
    {
      "id": "sfh6bkj",
      "link": "/api/v1/json/kits/sfh6bkj"
    },
    ...
  ]
}
$
```

In the interactive mode:
```
> show kits
{
  "kits": [
    {
      "id": "sfh6bkj",
      "link": "/api/v1/json/kits/sfh6bkj"
    },
    ...
  ]
}
>
```

### Show the description of a kit
```
> show kits sfh6bkj
{
  "kit": {
    "id": "sfh6bkj",
    "name": "Ivan Ukhov at Home",
    "analytics": false,
    "badge": false,
    "domains": [
      "ivanukhov.com",
      "localhost:3000"
    ],
    ...
  }
}
>
```

### Show the font families in a kit
```
> show kits sfh6bkj families
{
  "families": [
    {
      "id": "mpmb",
      "name": "Omnes Pro",
      "slug": "omnes-pro",
      "css_names": [
        "omnes-pro"
      ],
      "css_stack": "\"omnes-pro\",sans-serif",
      "subset": "default",
      "variations": [
        "n1",
        "n2"
      ]
    }
  ]
}
>
```

### Show the font families in the trial library with pagination
```
> show libraries trial { "page": 10, "per_page": 2 }
{
  "library": {
    "id": "trial",
    "link": "/api/v1/json/libraries/trial",
    "name": "Trial Library",
    "families": [
      {
        "id": "bfnx",
        "link": "/api/v1/json/families/bfnx",
        "name": "Anisette STD Petite SC"
      },
      {
        "id": "rnhy",
        "link": "/api/v1/json/families/rnhy",
        "name": "Anivers"
      }
    ],
    "pagination": {
      "count": 260,
      "on": "families",
      "page": 10,
      "page_count": 130,
      "per_page": 2
    }
  }
}
>
```

### Create a new kit
```
> create kits { "name": "Megakit", "domains": [ "example.com", "example.net" ] }
{
  "kit": {
    "id": "rtf5rkp",
    "name": "Megakit",
    "analytics": false,
    "badge": true,
    "domains": [
      "example.com",
      "example.net"
    ],
    "families": [

    ]
  }
}
>
```

### Disable the badge of a kit
```
> update kits rtf5rkp { "badge": false }
{
  "kit": {
    "id": "rtf5rkp",
    "name": "Megakit",
    "analytics": false,
    "badge": false,
    "domains": [
      "example.com",
      "example.net"
    ],
    "families": [

    ]
  }
}
>
```

### Add Proxima Nova into a kit
```
> update kits rtf5rkp { "families": { "0": { "id": "vcsm" } } }
{
  "kit": {
    "id": "rtf5rkp",
    "name": "Megakit",
    "analytics": false,
    "badge": false,
    "domains": [
      "example.com",
      "example.net"
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
        "css_stack": "\"proxima-nova-1\",\"proxima-nova-2\",sans-serif",
        "subset": "default",
        ...
      }
    ]
  }
}
>
```
Note that this query overwrites the font families contained in the kit.

### Delete a kit
```
> delete kits rtf5rkp
{
  "ok": true
}
>
```

## Contributing

1. Fork it ( https://github.com/IvanUkhov/typekit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
