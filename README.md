# RESTful ETL

> A promising asynchronous, non-blocking data integration library
> written in javascript.

RESTful ETL is an extract, transform, and load (ETL) library that interprets
classic Kimball Method data warehouse and ETL patterns with the modern
asynchronous, non-blocking advantages of node.js.

Designed for applications small enough that bulk loading is not required, the
library relies on RESTful API interfaces for data sources, destinations, and
its own operation.

## Usage

A user or application sends a `POST` to the batch endpoint with the batch type
and credentials for source and destination endpoints.

```json
Example JSON request
```

A new ETL "batch" is created based on the template specified in the batch type.

```json
Example JSON response
```

A batch is a set of extract, transform, and load jobs. Each of these jobs, in
turn, are based on job types (e.g. "Extract Salesforce customers" or "Load
QuickBooks bills") that specify the required behavior.

As the server executes the batch, the user or application can ping the batch
endpoint for updated status or establish a socket connection for a real time
status feed.

## Server features

* fully restful api
* audit table and quality screens
* error table
* schedules
* batches and jobs
* batch types and job types?
* socket broadcasts for real time status consumption
* tenant id

## ETL execution

### Batches

#### Batches vs streaming

In a real-time data integration environment, data is continuously fed from source systems to destination systems. In our case, the use of "batches" is intended to provide a periodically (hourly, daily, weekly) update. However, since the data flow is managed on a record-at-a-time basis and not with bulk loading, the "batch" concept is partially semantic.

As endpoints for webhooks are added to this library, the user will be able to process streaming real time data with or without an initial batch data load.

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

## Future features

* endpoint for real time hooks

## Contributing

Please see [CONTRIBUTING.md](https://github.com/activecell/restful-etl/blob/master/CONTRIBUTING.md).

## Anything we missed?

If there's anything at all that you need or want to know, please log an
[issue](https://github.com/activecell/restful-etl/issues) and we will
try to get you sorted out straight away.
