## Typekit Client (develop)

* Implementation of the Active Record design pattern: each resource got a set
  of methods for manipulating its data (e.g., `kit.save` and `kit.delete`).
* Support for Ruby >= 1.9.3 instead of Ruby >= 2.1.

## Typekit Client 0.0.5 (June 10, 2014)

* New name for the general CLI: `typekit-client` instead of `typekit`.
* New CLI for the sole purpose of publishing kits: `typekit-publisher`.
* Relations between resources (a kit has families, a family has variations,
  a variation belongs to a family, etc.).

## Typekit Client 0.0.4 (June 1, 2014)

* Extraction of the RESTful API logic into a separate gem called
  [Apitizer](https://github.com/IvanUkhov/apitizer).
* Elimination of the `--version` and `--format` options of the CLI.

## Typekit Client 0.0.3 (May 31, 2014)

* Object-restful mapping (families, kits, etc. got proper classes).
* Command history and tab completion in the CLI.

## Typekit Client 0.0.2 (May 28, 2014)

* New name for the gem (still `require 'typekit'`).
* Basic DSL for describing RESTful resources.
* Client-side verification of user requests.
* Refactoring, preparing for new features.

## Typekit 0.0.1 (May 16, 2014)
