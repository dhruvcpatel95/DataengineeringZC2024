variable "credentials" {
    description = "My Credentials"
    default = "./keys/my-creds.json"
}

variable "project" {
    description = "Project Name"
    default = "terraform-412420"
  
}

variable "region" {
  description = "region"
  default = "us-east"
}

variable "location" {
  description = "Project Location"
  default = "US"
}

variable "big_query_dataset_name" {
  description = "My BigQuery dataset name"
  default = "test_dataset"
}

variable "gcs_storage_name" {
    description = "Bucket Storage name"
    default = "terraform-412420-test-bucket"
}

variable "gcs_storage_class" {
    description = "Bucket Storage Class"
    default = "STANDARD"
}
