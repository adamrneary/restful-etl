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
* `batch_template`: An Object matching the format acceptable for a `POST` request to the batch endpoint. It is used to generate a new batch every time the schedule calls for a new batch
* `batches`: An Array of "batch" Objects representing the batches initiated on behalf of the schedule

## Sample requests and responses

/schedules

Sample GET response:

```json
[
  {
    id: '51b4ac524c9bfd8f2d000009',
    name: 'Daily QBD to Activecell refresh',
    frequency: "daiy",
    batch_template: {
      # same response as you would `POST` to batch endpoint
    },
    batches: [
      # an array of batches; same response as for `GET` to batch endpoint
    ]
  },
  # ...more schedules...
]
```

/schedules/:id

```json
{
  id: '51b4ac524c9bfd8f2d000009',
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batch_template: {
    # same response as you would `POST` to batch endpoint
  },
  batches: [
    # an array of batches; same response as for `GET` to batch endpoint
  ]
}
```

/schedules

Sample POST request:

{
  name: 'Daily QBD to Activecell refresh',
  frequency: "daiy",
  batch_template: {
    # same response as you would `POST` to batch endpoint
  }
}

```

You can also POST to

/schedules/batches

This will manually trigger a new batch for an existing schedule.

PUT to update
<!-- TODO: fill in this part -->

DELETE to update
<!-- TODO: fill in this part -->
