# Deploying your ML model in BigQuery 
### Steps
1. gcloud auth login
2. bq --project_id terraform-412420 extract -m ny_taxi.tip_model gs://taxi_ml_model_dp/tip_model
3. mkdir /tmp/model
4. gsutil cp -r gs://taxi_ml_model/tip_model /tmp/model
5. mkdir -p serving_dir/tip_model/1
6. cp -r /tmp/model/tip_model/* serving_dir/tip_model/1
7. docker pull tensorflow/serving
8. docker run -p 8501:8501 --mount type=bind,source=`pwd`/serving_dir/tip_model,target=/models/tip_model -e MODEL_NAME=tip_model -t tensorflow/serving &

### Test that the model is up and running
- Make a GET request
curl http://localhost:8501/v1/models/tip_model

- Make a POST request with a record to get the prediction for
curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' -X POST http://localhost:8501/v1/models/tip_model:predict
