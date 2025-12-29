variable "duckdns_domain" {
  description = "The name of your DuckDNS subdomain"
  type        = string
  default     = "poker-app"
}

variable "duckdns_token" {
  description = "The private token from your DuckDNS account"
  type        = string
  sensitive   = true
}
