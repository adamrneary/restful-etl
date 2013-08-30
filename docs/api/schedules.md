# API documentation: Schedules

## Fields:

* `id`: An immutable String assigned by the system on create
* `tenant_id`: A optional String to link a schedule to a specific tenant
* `name`: A String provided by the user to facilitate lookups
    * Note: The name must be unique within a given tenant
* `frequency`: A string indicating how often a new batch should be created
    * Valid frequencies
        * 'on_demand'
        * 'hourly
        * 'daily'
        * 'weekly'
        * 'monthly'
        * 'annually'
* `batches`: An Array of "batch" Objects representing the batches initiated on behalf of the schedule

## Sample requests and responses
#####/schedules
Sample GET response:
```json
[
  {
    id: '51b4ac524c9bfd8f2d000009',
    name: 'Daily QBD to Activecell refresh',
    frequency: "daiy",
    batches: [
      # an array of batches; same response as for `GET` to batch endpoint
    ]
  },
  # ...more schedules...
]
```

Sample POST request:
```json
{
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batches: [
    # an array of batches; same response as for `GET` to batch endpoint
  ]
}
```

Sample POST response:
```json
{
  id: '51b4ac524c9bfd8f2d000109',
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batches: [
    # an array of batches; same response as for `GET` to batch endpoint
  ]
}
```

#####/schedules/:id

Sample GET response:
```json
{
  id: '51b4ac524c9bfd8f2d000009',
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batches: [
    # an array of batches; same response as for `GET` to batch endpoint
  ]
}
```

Sample PUT request:
```json
{
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batches: [
    # an array of batches; same response as for `GET` to batch endpoint
  ]
}
```
Sample PUT response:

```json
{
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batches: [
    # an array of batches; same response as for `GET` to batch endpoint
  ]
}
```

Sample DELETE response:
```json
{
  id: '51b4ac524c9bfd8f2d000009',
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batches: [
    # an array of batches; same response as for `GET` to batch endpoint
  ]
}
```
