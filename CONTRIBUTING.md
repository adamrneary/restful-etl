# Contributing to RESTful-ETL

## Set up with script/bootstrap

We maintain script/bootstrap so you can run 1 script to set up your working
environment. If you had any dependencies that don't get picked up by `npm install`
then please make sure the appropriate flags are added to script/bootstrap.

## Style

We want to keep styles simple and consistent so that anyone 
can drop in and out of the project seamlessly.

* All javascript should be written in coffeescript
* All markup should be in templates
* All templates should be written in handlebars
* All css should be written in scss

## Tests

Please make sure all pull requests include tests that fail 
without your new functionality and pass with it.

* All functionality should be unit tested with mocha/chai
* All integration tests should be written in casper

## Documentation

* Please please please document your code in place.
* To document external data sources, please create a README in the directory of that
data source that explains:
    1. any authentication requirements
    1. any helpful notes on business rules
    1. the version of the API being accessed
