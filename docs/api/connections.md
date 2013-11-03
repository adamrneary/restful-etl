# API documentation: Connections

## Fields

* `id`: An immutable String assigned by the system on create
* `tenant_id`: A optional String to link a schedule to a specific tenant (included even if it is specified by a schedule)
* `name`: A String used for lookups
* `provider`: A String specifies the type of connection
* `realm`: A String used for Intuit authentication
* `oauth_consumer_key`: A String used for Intuit authentication
* `oauth_consumer_secret`: A String used for Intuit authentication
* `oauth_access_key`: A String used for Intuit authentication
* `oauth_access_secret`: A String used for Intuit authentication
* `subdomain`: A String used for ActiveCell authentication
* `company_id`: A String used for ActiveCell authentication
* `token`: A String used for ActiveCell authentication

## Sample requests and responses
#####/connection
Sample GET response:
```json
[{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QB',
  realm: '12345',
  oauth_consumer_key: 'asd8f9a09s8df09a8s7df098a7sdf0',
  oauth_consumer_secret: '89asd7f098a7sdf098a7sd08',
  oauth_access_key: '8as9d7f809a7sdf07as0d9as7d80f70',
  oauth_access_secret: 'asdf89a0sd80as8df0a89sd089a0sdf'
},
  # ...more connections...
]```

Sample POST request:
```json
{
  name: 'Quickbooks Desktop',
  provider: 'QB',
  realm: '12345',
  oauth_consumer_key: 'asd8f9a09s8df09a8s7df098a7sdf0',
  oauth_consumer_secret: '89asd7f098a7sdf098a7sd08',
  oauth_access_key: '8as9d7f809a7sdf07as0d9as7d80f70',
  oauth_access_secret: 'asdf89a0sd80as8df0a89sd089a0sdf'
}```

Sample POST response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QB',
  realm: '12345',
  oauth_consumer_key: 'asd8f9a09s8df09a8s7df098a7sdf0',
  oauth_consumer_secret: '89asd7f098a7sdf098a7sd08',
  oauth_access_key: '8as9d7f809a7sdf07as0d9as7d80f70',
  oauth_access_secret: 'asdf89a0sd80as8df0a89sd089a0sdf'
}```

#####/connection/:id
Sample GET response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QB',
  realm: '12345',
  oauth_consumer_key: 'asd8f9a09s8df09a8s7df098a7sdf0',
  oauth_consumer_secret: '89asd7f098a7sdf098a7sd08',
  oauth_access_key: '8as9d7f809a7sdf07as0d9as7d80f70',
  oauth_access_secret: 'asdf89a0sd80as8df0a89sd089a0sdf'
}```

Example PUT request:
```json
{
  name: 'Quickbooks Desktop',
  provider: 'QB',
  realm: '12345',
  oauth_consumer_key: 'asd8f9a09s8df09a8s7df098a7sdf0',
  oauth_consumer_secret: '89asd7f098a7sdf098a7sd08',
  oauth_access_key: '8as9d7f809a7sdf07as0d9as7d80f70',
  oauth_access_secret: 'asdf89a0sd80as8df0a89sd089a0sdf'
}```

Example PUT response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QB',
  realm: '12345',
  oauth_consumer_key: 'asd8f9a09s8df09a8s7df098a7sdf0',
  oauth_consumer_secret: '89asd7f098a7sdf098a7sd08',
  oauth_access_key: '8as9d7f809a7sdf07as0d9as7d80f70',
  oauth_access_secret: 'asdf89a0sd80as8df0a89sd089a0sdf'
}```

Sample DELETE response:
```json
{
  id: '51b4ac524c9bfd8f2d000002'
  name: 'Quickbooks Desktop',
  provider: 'QB',
  realm: '12345',
  oauth_consumer_key: 'asd8f9a09s8df09a8s7df098a7sdf0',
  oauth_consumer_secret: '89asd7f098a7sdf098a7sd08',
  oauth_access_key: '8as9d7f809a7sdf07as0d9as7d80f70',
  oauth_access_secret: 'asdf89a0sd80as8df0a89sd089a0sdf'
}```
