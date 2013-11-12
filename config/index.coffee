module.exports = {
  db_path: switch process.env.NODE_ENV
    when "development" then "mongodb://localhost:27017/etl"
    when "production" then  "mongodb://localhost:27017/etl"
    when 'test' then "mongodb://localhost:27017/etl-test"
    else  "mongodb://localhost:27017/etl"
  activecell_protocol: switch process.env.NODE_ENV
    when "development" then "http"
    when "production" then  "http"
    when 'test' then "http"
    else  "http"
  activecell_domain: switch process.env.NODE_ENV
    when "development" then "activecell.dev:3000"
    when "production" then  "activecell.dev:3000"
    when 'test' then "activecell.dev:3000"
    else  "activecell.dev:3000"
  app_port: switch process.env.NODE_ENV
    when "development" then 7171
    when "production" then  7171
    when 'test' then 7171
    else  7171
}