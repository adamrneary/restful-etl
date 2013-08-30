# API documentation: Batches

## Fields

* `id`: An immutable String assigned by the system on create
* `tenant_id`: A optional String to link a schedule to a specific tenant (included even if it is specified by a schedule)
* `source\connection\id`: A String to link the batch to a connection used as a source
* `destination\connection\id`: A String to link the batch to a connection used as a destination
* `since`: An optional Unix timestamp specifying the earliest point in the data itself that should be requested. See note below.
* `updated_since`: An optional Unix timestamp to allow for incremental updates. Only records updated after this point will be requested, regardless of any timing specified in the data
* `jobs`: An Array of job items, each containing a set of tasks (see below)

### Job and task fields

* extract
    * source\connection\id: An optional String to override source connection for the specific extract task
    * object: A String identifying the object endpoint within the source system to extract
    * grain: An optional String used for summary reports that can be extracted at various grains (e.g. daily, monthly)
    * since: An optional String to override the since variable used in the batch (not commonly used)
    * updated\since: An optional String to override the updated\_since variable used in the batch (not commonly used)
* load:
    * destination\connection\id: An optional String to override destination connection for the specific load task
    * object: A String identifying the object endpoint within the destination system to load
    * allowDelete: A Boolean value specifying whether to allow deletions (see below)
    * since: An optional String to override the since variable used in the batch (not commonly used)

### A note on "since" and "updated_since_"


### A note a allowing deletions

## Sample requests and responses

#####/batch
Sample GET response:
```json
[
  {
   id: '51b4ac524c9bfd8f2d0a0002'
   source: {
     connection:{
       id: '51b4ac524c9bfd8f2d000002'
     }
   },
   destination: {
     connection: {
       id: '51acded6a60c22e94d000004'
     }
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
,
  # ...more batches...
]```

Sample POST request:
{
  source: {
    connection:{
      id: '51b4ac524c9bfd8f2d000002'
    }
  },
  destination: {
    connection: {
      id: '51acded6a60c22e94d000004'
    }
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

Sample POST response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source: {
    connection:{
      id: '51b4ac524c9bfd8f2d000002'
    }
  },
  destination: {
    connection: {
      id: '51acded6a60c22e94d000004'
    }
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

#####/batch/:id
Sample GET response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source: {
    connection:{
      id: '51b4ac524c9bfd8f2d000002'
    }
  },
  destination: {
    connection: {
      id: '51acded6a60c22e94d000004'
    }
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

Sample PUT request:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source: {
    connection:{
      id: '51b4ac524c9bfd8f2d000002'
    }
  },
  destination: {
    connection: {
      id: '51acded6a60c22e94d000004'
    }
  },
  since: '2010-01-01',
  jobs: [
    {
      extract: {
        object: 'new Bills',
      },
      load: {
        object: 'new financial history',
        allowDelete: true
      }
    }, {
      extract: {
        object: 'new Balance Sheet Standard',
        grain: 'monthly'
      },
      load: {
        object: 'financial history',
        allowDelete: true
      }
    }
  ]
}

Sample PUT response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source: {
    connection:{
      id: '51b4ac524c9bfd8f2d000002'
    }
  },
  destination: {
    connection: {
      id: '51acded6a60c22e94d000004'
    }
  },
  since: '2010-01-01',
  jobs: [
    {
      extract: {
        object: 'new Bills',
      },
      load: {
        object: 'new financial history',
        allowDelete: true
      }
    }, {
      extract: {
        object: 'new Balance Sheet Standard',
        grain: 'monthly'
      },
      load: {
        object: 'financial history',
        allowDelete: true
      }
    }
  ]
}

Sample DELETE response:
{
  id: '51b4ac524c9bfd8f2d0a0002'
  source: {
    connection:{
      id: '51b4ac524c9bfd8f2d000002'
    }
  },
  destination: {
    connection: {
      id: '51acded6a60c22e94d000004'
    }
  },
  since: '2010-01-01',
  jobs: [
    {
      extract: {
        object: 'new Bills',
      },
      load: {
        object: 'new financial history',
        allowDelete: true
      }
    }, {
      extract: {
        object: 'new Balance Sheet Standard',
        grain: 'monthly'
      },
      load: {
        object: 'financial history',
        allowDelete: true
      }
    }
  ]
}
