
# Create AKS with Terraform and Github Actions

#### Install Terraform 
<pre><code>$ sudo apt-get update && sudo apt-get install -y gnupg software-properties-common 
$ wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
$ gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
$ sudo apt update
$ sudo apt-get install terraform
</code></pre>

#### Install AZ Cli
<pre><code>$ sudo apt-get update
$ sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
$ curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
 AZ_REPO=$(lsb_release -cs)
$ echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
$ sudo apt-get update
$ sudo apt-get install azure-cli
</code></pre>

## Create Blob Storage for tfstate
 <pre><code>$ export RESOURCE_GROUP_NAME=tfstate
$ export STORAGE_ACCOUNT_NAME=tfstate$RANDOM
$ export CONTAINER_NAME=tfstate</code></pre>

#### Create resource group
 <pre><code>$ az group create --name $RESOURCE_GROUP_NAME --location southeastasia</code></pre>

#### Create storage account
 <pre><code>$ az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob</code></pre>

#### Create blob container
 <pre><code>$ az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME</code></pre>

#### Export Account Key to env
 <pre><code>$ export ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
$ export ARM_ACCESS_KEY=$ACCOUNT_KEY</code></pre>

## Create SPN to integrate with Github and Azure
 <pre><code>$ az ad sp create-for-rbac --name=“github” --role="Contributor" --scopes="/subscriptions/6fe48053-9347-440c-a003-028b264f4204" --sdk-auth</code></pre>

## For Manual Apply IAC to Azure.
#### Initialize the backend storage
<pre><code>$ terraform init </code></pre>
#### Check the output of configuration
<pre><code>$ terraform plan </code></pre>
#### Apply the configuration
<pre><code>$ terraform apply </code></pre>
#### Destroy the Infrastructure
<pre><code>$ terraform destroy </code></pre>

## Techanical Challenge

- Learn spn
- Learn azurerm storage backend