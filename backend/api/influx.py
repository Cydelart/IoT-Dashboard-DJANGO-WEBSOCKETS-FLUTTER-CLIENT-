from influxdb_client import InfluxDBClient

url = "http://localhost:8086"
token = "wxQPz3KVMLbRJp7EY0vzWcAlkbZlWOE0NxJ4dTrffMrHlU4Udxsou6NZKeXYfZ9m02EeiwBgbCiyJuZWjlPqMw=="
org = "ISG"
bucket = "telemetry"

client = InfluxDBClient(url=url, token=token, org=org)

def get_history(device_id: int):
    query = f'''
        from(bucket: "{bucket}")
            |> range(start: -3h)
            |> filter(fn: (r) => r["_measurement"] == "telemetry")
            |> filter(fn: (r) => r["device_id"] == "{device_id}")
            |> keep(columns: ["_time", "_value"])
    '''

    tables = client.query_api().query(query)
    results = []

    for table in tables:
        for row in table.records:
            results.append({
                "timestamp": row.get_time().isoformat(),
                "value": row.get_value()
            })
            
    return results