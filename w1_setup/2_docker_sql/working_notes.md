# General Notes

## connect to the server using pgcli
pgcli -h localhost -p 5432 -u root -d ny_taxi



# Terraform
Infrastructure as code
- simple to keep track of infrastructure
- Easier collaboration 
- Reproducibility 
- Ensure resources are removed (so you don't leave behind any resources that keep charging you)

## Key commands
- init - get me the providers I need
- plan - what am I about to do?
- apply - do what is is in the tf files (create the resources in the cloud)
- destroy - remove everything defined in the tf files (delete the resources from the cloud)

