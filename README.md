# Tailscale Exit Node provisioning in Digital Ocean

This is an example of how Tailscale Exit Node can be provisioned in Digital Ocean with help of the Terraform.
Complimentary [blog post](https://sergeykibish.com/blog/tailscale-based-vpn-on-digitalocean-droplet).

Docs are generated with:

```sh
terraform-docs markdown table --output-file README.md --output-mode inject .
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.tailscale](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_ssh_key.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key) | resource |
| [digitalocean_tag.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/tag) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | Digital Ocean Read & Write token (https://cloud.digitalocean.com/account/api/tokens). | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | Path to SSH Key file (e.g. $HOME/.ssh/id). | `string` | n/a | yes |
| <a name="input_ssh_key_pub"></a> [ssh\_key\_pub](#input\_ssh\_key\_pub) | Path to SSH Public Key file (e.g. $HOME/.ssh/id.pub). | `string` | n/a | yes |
| <a name="input_tailscale_key"></a> [tailscale\_key](#input\_tailscale\_key) | Tailscale Auth Key (https://login.tailscale.com/admin/settings/keys). | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
