# Створення STREAM
curl.exe -X POST http://localhost:8088/ksql `
  -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" `
  --data-binary "@ksql-create-stream.json"

# Створення TABLE
curl.exe -X POST http://localhost:8088/ksql `
  -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" `
  --data-binary "@ksql-create-table.json"



curl.exe -X "POST" "http://localhost:8088/query"  -H "Content-Type: application/json"  -d '{ "sql": "SELECT * FROM unique_fb_posts EMIT CHANGES;", "streamProperties": { "ksql.streams.auto.offset.reset": "earliest" } '