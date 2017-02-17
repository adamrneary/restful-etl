# RESTful ETL

> A promising asynchronous, non-blocking data integration library
> written in javascript.

RESTful ETL is an extract, transform, and load (ETL) library that interprets
classic Kimball Method data warehouse and ETL patterns with the modern
asynchronous, non-blocking advantages of node.js.

Designed for applications small enough that bulk loading is not required, the
library relies on RESTful API interfaces for data sources, destinations, and
its own operation.

## Terminology:

* A **connection** is an object containing credentials for a known data source/destination.
* A **task** is the most atomic type of action that can be taken in the system, and tasks are either of type extract, transform, or load
    * **Extract tasks** retrieve data from the source. They do not change depending on the destination. Given a valid connection, extract jobs use `GET` requests to extract data without concern for how the data will be transformed or loaded.
    * **Load tasks** use `GET`, `POST`, and `PUT` requests to append, update, and delete records in the destination without concern for how the data was extracted or loaded.
    * Thusly, the **transformation task** that sits between the two need only provide a means of transforming data rows from the source interface to the destination. A library of common data transformations facilitates this process, though most transformations required are simple data manipulations easily handled by rudimentary javascript.
* A **job** is an array of tasks--a single flow of data through the system--and it typically consists of an extract, a transform, and a load task (though in the request, the transform task is generally inferred from the extract and load tasks)
* A **batch** is an array of jobs to be performed at the same time. They can maintain dependencies to ensure that data from one job is available for subsequent jobs.
* A **schedule** is an array of batches along with metadata about how frequently to execute future batches. Note, a new batch can be triggered manually within a schedule, and that batch will be associated with all other batches in the schedule.

## Usage

A user or application sends `POST`s to the connection endpoint to establish connections to be used in future batches.

Example JSON request:

```javascript

{
  name: 'Quickbooks Desktop',
  provider: 'QBD',
  realm: '12345',
  oauth\_consumer\_key: '',
  oauth\_consumer\_secret: ''
}

```

A valid connection will return a connection object that can be used for future batches.

Example JSON response:

```javascript

{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QBD',
  realm: '12345',
  oauth\_consumer\_key: '',
  oauth\_consumer\_secret: ''
}

```

A user or application may then send a `POST` to the batch endpoint with the configuration required.
Example JSON request:

```javascript

{
  source: {
    name: 'Quickbooks Desktop',
    connection_id: '51b4ac524c9bfd8f2d000002'
  },
  destination: {
    name: 'Activecell',
    connection_id: '51acded6a60c22e94d000004'
  },
  since: '2010-01-01',
  jobs: [
    {
      extract: {
        object: 'Bills',
      },
      load: {
        object: 'financial history',
        allowDelete: true
      }
    }, {
      extract: {
        object: 'Balance Sheet Standard',
        grain: 'monthly'
      },
      load: {
        object: 'financial history',
        allowDelete: true
      }
    }
  ]
}
```

In the above case, it is presumed that either:

1. The library has a transformation job converting the output of QuickBooks Desktop bills to Activecell financial history, or
2. No transformation is required, and that posting the QuickBooks desktop bills data to Activecell financial history will achieve the desired results

In addition, the above case presumes that valid connection objects have been established to both QuickBooks Desktop and Activecell, and that these connections can be used for `GET`, `POST`, and `PUT` requests as required.

A new ETL "batch" is created based on the template specified in the batch type.

Example JSON response:
```javascript

{
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batch: {
    source: {
      name: 'Quickbooks Desktop',
      connection: '51b4ac524c9bfd8f2d000002'
    },
    destination: {
      name: 'Activecell',
      connection: '51acded6a60c22e94d000004'
    },
    since: '2010-01-01'
    # ...etc...
  }
}
```

As the server executes the batch, the user or application can ping the batch
endpoint for updated status or establish a socket connection for a real time
status feed.

If the user or app wants to set up a recurring schedule for batches, a simple `POST` can manage this:

Example JSON request:
```javascript


```

## Server features

* Fully RESTful api
* Audit table and quality screens
* Error table
* Schedules
* Batches and individual jobs
* Socket broadcasts for real time status consumption
* Multi-tenant architecture

## ETL execution

### Batches

#### Batches vs streaming

In a real-time data integration environment, data is continuously fed from source systems to destination systems. In our case, the use of "batches" is intended to provide a periodically (hourly, daily, weekly) update. However, since the data flow is managed on a record-at-a-time basis and not with bulk loading, the "batch" concept is partially semantic.

As endpoints for webhooks are added to this library, the user will be able to process streaming real time data with or without an initial batch data load.

Example real time JSON request:

```javascript

{
  source: {
    name: 'Quickbooks Desktop',
  },
  destination: {
    name: 'Activecell',
    connection_id: '51acded6a60c22e94d000004'
  },
  jobs: [
    {
      extract: {
        object: 'Bills',
        data: [data object to transform and load]
      },
      load: {
        object: 'financial history',
        allowDelete: false
      }
    }
  ]
}

### Extract jobs

e.g. Extract QuickBooks bills

* full or incremental
* links to metadata
* consolidates paged data
* stages in memory, redis, or mongo
* ends with promise/callback/notification

### Transform jobs

e.g. Quickbooks bills to Activecell financial history

* simple transforms
* lookups
* stages in memory, redis, or mongo
* ends with promise/callback/notification

### Load jobs

e.g. Load Activecell financial history

* pull destination dataset
* append, update, delete
* scd
* links to destination api metadata

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
