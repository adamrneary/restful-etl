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
Example POST request:
```json
{
  name: 'Quickbooks Desktop',
  provider: 'QBD',
  realm: '12345',
  oauth: {
    consumer: {
      key: '',
      secret
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
      secret
    }
  }
}```

#####/connection/:id
Example get request:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
}```

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
      secret
    }
  }
}```



