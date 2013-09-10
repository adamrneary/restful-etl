# API documentation: Tenants

## Fields

* `id`: An immutable String assigned by the system on create
* `name`: A String used for lookups

## Sample requests and responses
#####/tenant
Example POST request:
```json
{
  name: 'my tenant'
}```

Sample POST response:
```json
{
  id: '51b4ac524c9bfd8f2d0000a0',
  name: 'my tenant'
}```

Sample GET response:
```json
[{
  id: '51b4ac524c9bfd8f2d0000a0',
  name: 'my tenant'
},
  # ...more tenants...

]
```

#####/tenant/:id
Sample GET response:
```json
{
  id: '51b4ac524c9bfd8f2d0000a0',
  name: 'new tenant'
}```

Sample PUT request:
```json
{
  name: 'new tenant'
}```

Sample PUT response:
```json
{
  id: '51b4ac524c9bfd8f2d0000a0',
  name: 'new tenant'
}```

Sample DELETE response:
```json
{
  id: '51b4ac524c9bfd8f2d0000a0',
  name: 'new tenant'
}```

