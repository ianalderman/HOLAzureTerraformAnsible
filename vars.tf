 variable subscription_id {
     description = "Azure Subscription Id"
     default = ""
 }

 variable client_id {
     description = "The appId of the Service Principal for use with Terraform"
     default = ""
 }

 variable client_secret {
     description = "The password of the Service Principal for use with Terraform"
     default = ""
 }

variable tenant_id {
    description = "The Tenant id for the Azure Subscription"
    default = ""
}

variable StudentId {
    description = "The unique number for the student in this Lab"
    default = "1"
}

variable azure_region {
    description = "The azure region to deploy to e.g., northeurope"
    default = "northeurope"
}
