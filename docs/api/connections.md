# API documentation: Connections

## Fields

* `id`: An immutable String assigned by the system on create
* `tenant_id`: A optional String to link a schedule to a specific tenant (included even if it is specified by a schedule)
* `provider`: TODO: provider description
* `realm`: TODO: realm description
* `oauth/consumer/key`: TODO: key description
* `oauth/consumer/secret`: TODO: secret description

## Sample requests and responses
#####/connection
Sample GET response:
```json
[{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret: ''
    }
  }
},
  # ...more connections...
]```

Sample POST request:
```json
{
  name: 'Quickbooks Desktop',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret: ''
    }
  }
}```

Sample POST response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret: ''
    }
  }
}```

#####/connection/:id
Sample GET response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret: ''
    }
  }
}```

Example PUT request:
```json
{
  name: 'Dashboard',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret: ''
    }
  }
}```

Example PUT response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Dashboard',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret: ''
    }
  }
}```

Sample DELETE response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Dashboard',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret: ''
    }
  }
}```
