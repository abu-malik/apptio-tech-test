terraform {
  backend "s3" {
    # Replace BUCKETNAME with your personal bucket where you want to save terraform state file. You can also change other variables as per the requirements 
	bucket     = "BUCKETNAME"
    key        = "terraform.tfstate"
    region     = "eu-west-2"
    encrypt    = "true"
  }
}