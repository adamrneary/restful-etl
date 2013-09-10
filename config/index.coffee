module.exports = {
  db_path: switch process.env.NODE_ENV
    when 'test' then 'etl-test'
    else 'etl'
}