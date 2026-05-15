path "secret/data/homelab/*" {
  capabilities = ["read"]
}

path "secret/metadata/homelab/*" {
  capabilities = ["read", "list"]
}