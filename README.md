# RESTful ETL

> A promising asynchronous, non-blocking data integration library 
> written in javascript.

RESTful ETL is a ETL library that interprets classic Kimball Method data
warehouse and ETL patterns with modern  asynchronous, non-blocking advantages
of node.js.

## Usage

The interface for all operations is a RESTful API.

` 

## Server features

* fully restful api
* audit table and quality screens
* error table
* schedules
* batches and jobs
* batch types and job types?
* real time hooks
* socket broadcasts for real time status consumption
* tenant id

## ETL execution

### Batches

### Extract jobs

* can consume passed credentials but does not store credentials
* full or incremental
* links to metadata
* stages in memory, redis, or mongo
* ends with promise/callback/notification

### Transform jobs

* simple transforms
* lookups
* stages in memory, redis, or mongo
* ends with promise/callback/notification

### Load jobs

* pull destination dataset
* scd
* links to destination api

## Client features

### When batches are not running

* last sync
* connected since
* button to initiate full re-sync of data
* sync history
* audit, data quality screens output

### When batches are running

* status table with job list, updated in real time
* error table
* cancel, restart

## Contributing

Please see [CONTRIBUTING.md](https://github.com/activecell/restful-etl/blob/master/CONTRIBUTING.md).

## Anything we missed?

If there's anything at all that you need or want to know, please log an 
[issue](https://github.com/activecell/restful-etl/isssues) and we will 
try to get you sorted out straight away.
