# API documentation: Batches

## Fields

* `id`: An immutable String assigned by the system on create
* `tenant_id`: A optional String to link a schedule to a specific tenant (included even if it is specified by a schedule)
* `source_connection_id`: A String to link the batch to a connection used as a source
* `destination_connection_id`: A String to link the batch to a connection used as a destination
* `since`: An optional Unix timestamp specifying the earliest point in the data itself that should be requested. See note below.
* `updated_since`: An optional Unix timestamp to allow for incremental updates. Only records updated after this point will be requested, regardless of any timing specified in the data
* `jobs`: An Array of job items, each containing a set of tasks (see below)

### Job and task fields
* type String specifies the type of work, can be "load" or "extract"
* object: A String identifying the object endpoint within the source system to extract
* grain: An optional String used for summary reports that can be extracted at various grains (e.g. daily, monthly)
* since: An optional String to override the since variable used in the batch (not commonly used)
* updated\since: An optional String to override the updated\_since variable used in the batch (not commonly used)
* required_objects An object specifies which objects need to wait, contains three arrays: "extract", "load", "load_result"


### A note on "since" and "updated_since"


### A note a allowing deletions

## Sample requests and responses

#####/batch
Sample GET response:
```json
[
  {
   id: '51b4ac524c9bfd8f2d0a0002',
   source_connection_id: '51b4ac524c9bfd8f2d000003',
   destination_connection_id: '51acded6a60c22e94d000004',
   since: '2010-01-01',
   jobs: [
      {
        type": "extract",
        object": "Account"
      },
      {
        type": "load",
        object": "accounts",
        required_objects:{
          extract: ["Account"]
      }
   ]
 }
,
  # ...more batches...
]```

Sample POST request:
{
  source_connection_id: '51b4ac524c9bfd8f2d000003',
  destination_connection_id: '51acded6a60c22e94d000004',
  since: '2010-01-01',
  jobs: [
      {
        type": "extract",
        object": "Account"
      },
      {
        type": "load",
        object": "accounts",
        required_objects:{
          extract: ["Account"]
      }
  ]
}

Sample POST response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source_connection_id: '51b4ac524c9bfd8f2d000003',
  destination_connection_id: '51acded6a60c22e94d000004',
  since: '2010-01-01',
  jobs: [
      {
        type": "extract",
        object": "Account"
      },
      {
        type": "load",
        object": "accounts",
        required_objects:{
          extract: ["Account"]
      }
  ]
}

#####/batch/:id
Sample GET response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source_connection_id: '51b4ac524c9bfd8f2d000003',
  destination_connection_id: '51acded6a60c22e94d000004',
  since: '2010-01-01',
  jobs: [
      {
        type": "extract",
        object": "Account"
      },
      {
        type": "load",
        object": "accounts",
        required_objects:{
          extract: ["Account"]
      }
  ]
}

Sample PUT request:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source_connection_id: '51b4ac524c9bfd8f2d000003',
  destination_connection_id: '51acded6a60c22e94d000004',
  since: '2010-01-01',
  jobs: [
      {
        type": "extract",
        object": "Account"
      },
      {
        type": "load",
        object": "accounts",
        required_objects:{
          extract: ["Account"]
      }
  ]
}

Sample PUT response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source_connection_id: '51b4ac524c9bfd8f2d000003',
  destination_connection_id: '51acded6a60c22e94d000004',
  since: '2010-01-01',
  jobs: [
      {
        type": "extract",
        object": "Account"
      },
      {
        type": "load",
        object": "accounts",
        required_objects:{
          extract: ["Account"]
      }
  ]
}

Sample DELETE response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source_connection_id: '51b4ac524c9bfd8f2d000003',
  destination_connection_id: '51acded6a60c22e94d000004',
  since: '2010-01-01',
  jobs: [
      {
        type": "extract",
        object": "Account"
      },
      {
        type": "load",
        object": "accounts",
        required_objects:{
          extract: ["Account"]
      }
  ]
}
