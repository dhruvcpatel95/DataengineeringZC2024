import io
import os
import requests
import pandas as pd
from google.cloud import storage

"""
Pre-reqs: 
1. `pip install pandas pyarrow google-cloud-storage`
2. Set GOOGLE_APPLICATION_CREDENTIALS to your project/service-account key
3. Set GCP_GCS_BUCKET as your bucket or change default value of BUCKET
"""

import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/workspaces/DataengineeringZC2024/w1_setup/3_terraform/keys/my-creds.json"

# services = ['fhv','green','yellow']
init_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/'
# switch out the bucketname
BUCKET = os.environ.get("GCP_GCS_BUCKET", "nyc-taxi-data-dp")


def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    """
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    # storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    # storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)


def web_to_gcs(year, service):
    for i in range(12):
        
    #     # sets the month part of the file_name string
        month = '0'+str(i+1)
        month = month[-2:]

    #     # csv file_name
        file_name = f"{service}_tripdata_{year}-{month}.csv.gz"

    #     # download it using requests via a pandas df
    #     request_url = f"{init_url}{service}/{file_name}"
    #     r = requests.get(request_url)
        path = '/workspaces/DataengineeringZC2024/w3_data_warehouse/data/'
    #     open(path+file_name, 'wb').write(r.content)
    #     print(f"Local: {file_name}")

    #     # read it back into a parquet file
    #     
#         print('starting reading into parquet')
#         df = pd.read_csv(path+file_name, compression='gzip')
        file_name = file_name.replace('.csv.gz', '.parquet')
#         df.to_parquet(path+file_name, engine='pyarrow')
#         print(f"Parquet: {file_name}")
#    
#         print(e)

        # upload it to gcs 
        upload_to_gcs(BUCKET, f"{service}/{str(year)}/{file_name}", path+file_name)
        print(f"GCS: {service}/{file_name}")

web_to_gcs('2019', 'fhv')
# web_to_gcs('2019', 'green')
# web_to_gcs('2020', 'green')
# web_to_gcs('2019', 'yellow')
# web_to_gcs('2020', 'yellow')

