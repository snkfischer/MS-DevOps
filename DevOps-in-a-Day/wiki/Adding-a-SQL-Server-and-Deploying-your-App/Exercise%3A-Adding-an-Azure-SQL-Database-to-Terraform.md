# Exercise: Adding an Azure SQL Database to Terraform

Start by opening the `standard_application` module's `main.tf` file. Add the following to the bottom:

```
resource "azurerm_sql_server" "standard_sql_server" {
  name                         = "tf-az-standard-sql-${var.environment}-${random_integer.ri.result}"
  resource_group_name          = "${azurerm_resource_group.application_rg.name}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.sql_administrator_login}"
  administrator_login_password = "${var.sql_administrator_password}"
}

resource "azurerm_sql_database" "app1_db" {
  name                = "tf-az-${var.application_name}-${var.environment}-db"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
}

resource "azurerm_sql_firewall_rule" "test" {
  name                = "tf-az-${var.application_name}-${var.environment}-allow-azure-sqlfw${random_integer.ri.result}"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
  start_ip_address    = "0.0.0.0" # tells Azure to allow Azure services
  end_ip_address      = "0.0.0.0" # tells Azure to allow Azure serivces
}
```

The first declaration creates an Azure SQL Server named `tf-az-standard-sql-{env}-{random-integer}` (you'll notice we re-used the same rnadom integer value to ensure the SQL Server name was unique). The second adds a database named `tf-az-${var.application_name}--${var.environment}-db` to the SQL Server. The third enables other Azure services to communicate with the SQL Server. 

Notice we left the `start_ip_address` and `end_ip_address` as hard-coded values. We want to keep these inputs static so we did not generalize them. This will also not affect the dynamic creation of said rule, as it should be the same every time it gets created by Terraform.

#### Update the module variables

You may have noticed we're using several new variables. Let's add them to the end of the `variables.tf` file:

```
variable "sql_administrator_login" {
    description = "Login for the Azure SQL Instance"
}

variable "sql_administrator_password" {
    description = "Password for the Azure SQL Instance"
}
```

#### Supply the module with variable values

After adding the variables, update the supplied values of the variables in your main.tf files (dev and prod) with the supplied values.

For dev:

```
module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "dev"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan_size      = "B1"
    sql_administrator_login    = "sqladmin"
    sql_administrator_password = "SQLP@ss123"
}
```

...and prod:

```
module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "prod"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan_size      = "B1"
    sql_administrator_login    = "sqladmin"
    sql_administrator_password = "SQLP@ss123"
}
```

## Testing your changes

Navigate to the dev folder, initialize Terraform:

```bash
terraform init
```

Run a plan to check out what's going to happen:

```bash
terraform plan
```

And apply the changes:

```bash
terraform apply
```

Go out to the Azure portal and check to see the resources have been created. 

## Getting the connection string to your database

Navigate to your dev SQL Database, and click on the *Connection strings* blade:

![connection-strings](\.attachments\images\Adding-a-SQL-Server-and-Deploying-your-App\connection-strings.png)

Copy the ADO.NET connection string and save it - you'll need this in the next step.

_This concludes the exercise and this section._

## What's Next

In this section, you learned how to deploy a SQL Server using Terraform. In the next section, you'll learn how to secure web apps deployed to Azure. 