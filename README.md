# insight-icon-iac-workshop

Code for Insight's SF Blockchain Week's infrastructure workshop.  Please follow the directions exactly as any deviations could have adverse consequences. 

Check out the presentation outlining the workshop [at this link.](https://docs.google.com/presentation/d/1iHPf9xboe8WnpOYD8Bk5O9h1oaKjVAI4oQXQtxe7dqs/edit?usp=sharing)

## Basic Steps 

1. Install requirements 
2. Get keys from AWS 
3. Fill in config files 
4. Run code 

## Install requirements 

This deployment was built to run on unix based systems.  If running a Windows machine, you will need to install WSL to run linux (Ubuntu recommended).  Python 3.6+ is required. 
 
### Python Dependencies 

- Cookiecutter 
    - `sudo pip3 install cookiecutter`
- Ansible 
    - `sudo pip3 install ansible`
- yq 
    - `sudo pip3 install yq`    
    
### Binaries 
    
- Terraform 
    - We suggest using [tfswitch](https://warrensbox.github.io/terraform-switcher/) 
        - Requires installing Go
    - Otherwise here are some options 
        - Windows
            - Install [chocolatey](https://chocolatey.org/docs/installation)
            - From command prompt run `choco install terraform`
        - Mac 
            - Install [brew](https://brew.sh/)
                - `brew install terraform`
        - Linux
            - Binary 
                - `wget https://releases.hashicorp.com/terraform/0.12.12/terraform_0.12.12_linux_amd64.zip -O /tmp/terraform.zip`
                - `unzip /tmp/terraform.zip -d /tmp/terraform`
                - `sudo mv /tmp/terraform /usr/local/bin/terraform`
                - `terraform --version` 
 
- Terragrunt
    - We suggest using [tgswitch](https://github.com/warrensbox/tgswitch))
    - Install from [source](https://github.com/gruntwork-io/terragrunt) 
    - Install 
        - Windows 
            - `choco install terragrunt`
        - Mac 
            - `brew install terragrunt`
        - Linux
            - Binary  
                - `wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.21.1/terragrunt_linux_amd64 -O /tmp/terragrunt`
                - `chmod +x /tmp/terragrunt`
                - `sudo mv /tmp/terragrunt /usr/local/bin/terragrunt`
                - `terragrunt --version` 

- Packer 
    - Install 
        - Windows
            - Install [chocolatey](https://chocolatey.org/docs/installation)
            - From command prompt run `choco install packer`
        - Mac 
            - Install [brew](https://brew.sh/)
                - `brew install packer`
        - Linux 
            - Binary 
                - `wget https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip -O /tmp/packer.zip`
                - `unzip /tmp/packer.zip -d /tmp/packer`
                - `sudo mv /tmp/packer /usr/local/bin`
                - `packer --version`


## Preparation
- Run `cookiecutter https://github.com/robc-io/cookiecutter-icon-p-rep-simple`
- Enter options - You can save your options in a yaml file as [documented below](#saving-config-values)
- Export these keys 
    - AWS_ACCESS_KEY_ID – Specifies an AWS access key associated with an IAM user or role.
    - AWS_SECRET_ACCESS_KEY – Specifies the secret key associated with the access key. This is essentially the "password" for the access key.
    - If you are using keys with aws profile, export the profile - `export AWS_PROFILE=<profile>`
- Ensure the IAM user provided has the AdministratorAccess role and no other policies are applied that explicitly deny

## Applying 

- To stand up the infrastructure run:
    - `cd <env> && ./tgrun.sh citizen apply`
    - You can run this multiple times without breaking it
- To destroy the infrastructure run:
    - `cd <env> && ./tgrun.sh citizen destroy`

### Saving Config Values 

It can be easier to set defaults in a yaml configuration file like this, 

```yaml
default_context:
    environment: "dev"
    region: "us-east-1"
    account_id: "987654321012"
    corporate_ip: "1.2.3.4"
    local_public_key: "full/path/to/.ssh/id_rsa.pub"
    local_private_key: "full/path/to/.ssh/id_rsa"
    keystore_path: "full/path/to/keystore"
    keystore_password: "scarystuff"
```

Then you just need to run cookiecutter like so,

```bash
cookiecutter --config-file=context.yaml https://github.com/robc-io/cookiecutter-icon-p-rep-simple
```

To suppress input run with additional flag `--no-input` flag:

```bash
cookiecutter --config-file=context.yaml https://github.com/robc-io/cookiecutter-icon-p-rep-simple --no-input
```

## Registration 

### Requirements 

```bash
sudo apt-get install -y libssl-dev build-essential automake pkg-config libtool libffi-dev libgmp-dev libyaml-cpp-dev
sudo apt-get install -y python3.7-dev libsecp256k1-dev python3-pip 
```

Install `preptools`
- `sudo pip3 install preptools`

### Fill Out Config Files 

This file needs to be local. 

prep.json 
```
{
    "name": "Insight",
    "country": "USA",
    "city": "San Francisco",
    "email": "insight.icon.prep@gmail.net",
    "website": "https://www.insight-icon.net",
    "details": "https://www.<YOUR SERVER DOMAIN>/<ANY PATH>/details.json",
    "p2pEndpoint": "<YOUR SERVER IP>:7100"
}
```

Make this available to the internet. See [this link](https://www.home.insight-icon.net/registration/details.json) for this example. 

details.json 
```
{
  "representative": {
    "logo": {
      "logo_256": "https://www.home.insight-icon.net/static/insight-logo-256.png",
      "logo_1024": "https://www.home.insight-icon.net/static/insight-logo-1024.png",
      "logo_svg": "https://www.home.insight-icon.net/static/insight-logo-256.svg"
    },
    "media": {
      "steemit": "",
      "twitter": "https://twitter.com/insight.icon.prep",
      "youtube": "https://www.youtube.com/channel/UCMPrlANYbIrpfgtQZQ0w7kw?view_as=subscriber",
      "facebook": "",
      "github": "https://github.com/insight-infrastructure",
      "reddit": "https://www.reddit.com/user/insight-icon",
      "keybase": "https://keybase.io/robc_io",
      "telegram": "https://t.me/robcio",
      "wechat": ""
    }
  },
  "server": {
    "location": {
      "country": "USA",
      "city": "us-east-1"
    },
    "server_type": "cloud",
    "api_endpoint": "<YOUR SERVER IP>:9000"
  }
}
```

### Run Registration Tooling 

```bash
preptools registerPRep -u https://ctz.solidwallet.io/api/v3 \
--nid 1 \
-k ./<YOUR KEYSTORE NAME> \
--prep-json prep.json  
```

where `prep.json` is from the last step. 

If something happens, and you want to change your server ip / details, run this, 

```bash
preptools setPRep -u https://ctz.solidwallet.io/api/v3 \
--nid 1 \
-k ./<YOUR KEYSTORE NAME> \
--prep-json prep.json  
```

## Fixing Builds 

What the script is doing under the hood is cycling through the modules and running `terragrunt apply` on each of them. If something breaks mid process, you can rerun apply whenever.  When you want to destroy, you need to remember to destroy the items in order otherwise errors occur. 

