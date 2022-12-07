resource "aci_tenant" "tf_tenant" {
  name        = var.tenant_name
  description = "Created by Terraform."
}

resource "aci_vrf" "tf_vrf" {
  tenant_dn   = aci_tenant.tf_tenant.id
  name        = var.vrf_name
  description = "Created by terraform"
}

resource "aci_bridge_domain" "tf_bd" {
  tenant_dn          = aci_tenant.tf_tenant.id
  description        = "Created by terraform"
  name               = var.bd_name
  relation_fv_rs_ctx = aci_vrf.tf_vrf.id
}

resource "aci_subnet" "tf_bd_subnet" {
  parent_dn   = aci_bridge_domain.tf_bd.id
  description = "BD Subnet"
  ip          = var.bd_subnet_cidr
}

resource "aci_application_profile" "tf_ap" {
  tenant_dn   = aci_tenant.tf_tenant.id
  name        = var.app_profile_name
  description = "Created by terraform"
}

resource "aci_application_epg" "tf_epg_web" {
  application_profile_dn = aci_application_profile.tf_ap.id
  name                   = "WEB"
  description            = "Created by terraform"
}

resource "aci_application_epg" "tf_epg_db" {
  application_profile_dn = aci_application_profile.tf_ap.id
  name                   = "DB"
  description            = "Created by terraform"
}

resource "aci_filter" "tf_filter_https" {
  tenant_dn   = aci_tenant.tf_tenant.id
  description = "Created by terraform"
  name        = "https"
}

resource "aci_filter_entry" "tf_filter_https_entry" {
  filter_dn   = aci_filter.tf_filter_https.id
  description = "From Terraform"
  name        = "https"
  d_from_port = "https"
  d_to_port   = "https"
  ether_t     = "ipv4"
  prot        = "tcp"
  s_from_port = "0"
  s_to_port   = "0"
}

resource "aci_filter" "tf_filter_sql" {
  tenant_dn   = aci_tenant.tf_tenant.id
  description = "Created by terraform"
  name        = "sql"
}

resource "aci_filter_entry" "tf_filter_sql_entry" {
  filter_dn   = aci_filter.tf_filter_sql.id
  description = "Created by terraform"
  name        = "sql"
  d_from_port = "3306"
  d_to_port   = "3306"
  ether_t     = "ipv4"
  prot        = "tcp"
  s_from_port = "0"
  s_to_port   = "0"
}

resource "aci_contract" "int_to_web_contract" {
  tenant_dn   = aci_tenant.tf_tenant.id
  description = "Created by terraform"
  name        = "INTERNET_TO_WEB"
}

resource "aci_contract_subject" "int_to_web_contract_subj" {
  contract_dn                  = aci_contract.int_to_web_contract.id
  description                  = "Created by terraform"
  name                         = "https"
  relation_vz_rs_subj_filt_att = [aci_filter.tf_filter_https.id]
}

resource "aci_contract" "web_to_db_contract" {
  tenant_dn   = aci_tenant.tf_tenant.id
  description = "Created by terraform"
  name        = "WEB_TO_DB"
}

resource "aci_contract_subject" "web_to_db_contract_subj" {
  contract_dn                  = aci_contract.web_to_db_contract.id
  description                  = "Created by terraform"
  name                         = "sql"
  relation_vz_rs_subj_filt_att = [aci_filter.tf_filter_sql.id]
}

resource "aci_epg_to_contract" "epg_web_prov_https" {
  application_epg_dn = aci_application_epg.tf_epg_web.id
  contract_dn        = aci_contract.int_to_web_contract.id
  contract_type      = "provider"
}

resource "aci_epg_to_contract" "epg_web_cons_sql" {
  application_epg_dn = aci_application_epg.tf_epg_web.id
  contract_dn        = aci_contract.web_to_db_contract.id
  contract_type      = "consumer"
}

resource "aci_epg_to_contract" "epg_db_prov_sql" {
  application_epg_dn = aci_application_epg.tf_epg_db.id
  contract_dn        = aci_contract.web_to_db_contract.id
  contract_type      = "provider"
}
