-- ML model example in Big Query

SELECT passenger_count, trip_distance, pulocationid, dolocationid, payment_type, fare_amount, tolls_amount, tip_amount
FROM `terraform-412420.ny_taxi.yellow_cab_data` 
WHERE fare_amount != 0;

-- CREATE a ML table with appropriate type
CREATE OR REPLACE TABLE `terraform-412420.ny_taxi.yellow_cab_data_ml`(
  `passenger_count` INTEGER,
  `trip_distance` FLOAT64,
  `pulocationid` STRING,
  `dolocationid` STRING,
  `payment_type` STRING,
  `fare_amount` FLOAT64,
  `tolls_amount` FLOAT64,
  `tip_amount` FLOAT64
) AS (
  SELECT passenger_count, trip_distance, cast(pulocationid AS STRING), cast(dolocationid AS STRING),
  cast(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
  FROM `terraform-412420.ny_taxi.yellow_cab_data`
  WHERE fare_amount != 0
);


-- CREATE A MODEL WITH DEFAULT SETTINGS
CREATE OR REPLACE MODEL `terraform-412420.ny_taxi.tip_model`
OPTIONS (
  model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT'
) AS
SELECT * FROM `terraform-412420.ny_taxi.yellow_cab_data_ml`
WHERE tip_amount IS NOT NULL;



-- CHECK FEATURES
SELECT * FROM ML.FEATURE_INFO(MODEL `terraform-412420.ny_taxi.tip_model`);

-- EVALUATE THE MODEL
SELECT * FROM ML.EVALUATE(MODEL `terraform-412420.ny_taxi.tip_model`,
  (
    SELECT * FROM `terraform-412420.ny_taxi.yellow_cab_data_ml`
  ));


-- PREDICT USING THE MODEL
SELECT * FROM ml.predict(MODEL `terraform-412420.ny_taxi.tip_model`,
  (
    SELECT * FROM `terraform-412420.ny_taxi.yellow_cab_data_ml` WHERE tip_amount IS NOT NULL
  ));


-- PREDICT AND EXPLAIN
SELECT * FROM ml.explain_predict(model `terraform-412420.ny_taxi.tip_model`,
(
    SELECT * FROM `terraform-412420.ny_taxi.yellow_cab_data_ml` WHERE tip_amount IS NOT NULL
), STRUCT(3 as top_k_features));


-- HYPER PARAM TUNING
CREATE OR REPLACE MODEL `terraform-412420.ny_taxi.tip_hyperparam_model`
OPTIONS (
  model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT',
  num_trials=5,
  max_parallel_trials=2,
  l1_reg=hparam_range(0, 20),
  l2_reg=hparam_candidates([0, 0.1, 1, 10])
) AS 
SELECT * FROM `terraform-412420.ny_taxi.yellow_cab_data_ml` WHERE tip_amount IS NOT NULL;








