# insight-icon-iac-workshop

Code for Insight's SF Blockchain Week's infrastructure workshop.  Please follow the directions exactly as any deviations could have adverse consequences. 

## Basic Steps 

1. Install requirements 
2. Get keys from AWS 
3. Fill in config files 
4. Run code 

## Install requirements 

This deployment was built to run on unix based systems.  If running a Windows machine, you will need to install WSL to run linux (Ubuntu recommended).  Python 3.6+ is required. 

### General Requirements 

```bash
sudo apt-get install -y libssl-dev build-essential automake pkg-config libtool libffi-dev libgmp-dev libyaml-cpp-dev
sudo apt-get install -y python3.7-dev libsecp256k1-dev python3-pip 
```
 
### Python Dependencies 


- preptools 
    - `sudo pip3 install preptools`
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
    - If you are using keys with aws profile, export the profile - `export AWS_PROFILE=profile`
- Ensure the IAM user provided has the AdministratorAccess role and no other policies are applied that explicitly deny

## Applying 

- Run `cd <env> && chmod +x apply.sh && ./apply.sh`
    - Might need to nudge it along by running terragrunt from within the directories or running apply twice
    - Sometimes there are errors with the content delivery system and various API calls 
- Run `chmod +x destroy.sh && ./destroy.sh` to destroy the resources 

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

### Notes

- Places where hard-codes exist 
    - logging bucket - ok 
    - global reference 
        - Need to deal with this somehow
        - This is best practice to put IAM and other globally scoped resources in their own folder
        - This obviously is going to cause a lot of issues 
        
