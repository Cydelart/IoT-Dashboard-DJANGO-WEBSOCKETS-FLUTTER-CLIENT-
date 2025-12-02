import random
import time
from influxdb_client import InfluxDBClient, Point, WritePrecision

# -------------------------------
# InfluxDB connection
# -------------------------------
url = "http://localhost:8086"
token = "wxQPz3KVMLbRJp7EY0vzWcAlkbZlWOE0NxJ4dTrffMrHlU4Udxsou6NZKeXYfZ9m02EeiwBgbCiyJuZWjlPqMw=="
org = "ISG"
bucket = "telemetry"

client = InfluxDBClient(url=url, token=token, org=org)
write_api = client.write_api()

device_id = 1  # ton device
sensor_type = "temperature"

while True:
    value = round(random.uniform(20, 35), 2)

    point = (
        Point("telemetry")
        .tag("device_id", str(device_id))
        .tag("sensor", sensor_type)
        .field("value", value)
        .time(time.time_ns(), WritePrecision.NS)
    )

    write_api.write(bucket=bucket, org=org, record=point)

    print(f"Sent: {value}")
    time.sleep(2)
