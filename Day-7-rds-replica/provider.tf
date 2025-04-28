provider "aws"{
    alias = "primary"
    region = "us-east-1" #primary region
}

provider "aws"{
    alias = "replica"
    region = "us-west-2" #replica region
}