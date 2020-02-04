param(
    [string]$orgName,
    [int]$users = 24
)

$DebugPreference = "Continue"
$InformationPreference = "Continue"

if(-not (Get-Command "az" -ErrorAction SilentlyContinue)) 
{
    throw "az command is not found.  Please check that the Azure CLI is installed and in the path."
}

if(-not $env:AZURE_DEVOPS_EXT_PAT)
{
    throw "Please set `$env:AZURE_DEVOPS_EXT_PAT environment variable."
}

$organization = ('https://dev.azure.com/{0}' -f $orgName)
$tenant = ('{0}.onmicrosoft.com' -f $orgName)

Write-Debug ("organization = {0}" -f $organization)
Write-Debug ("tenant = {0}" -f $tenant)

# TODO
# az devops admin banner add --org $organization --id Welcome --message "Welcome to KiZAN's DevOps in a Day Workshop!  This Azure DevOps organization is shared among all attendees.  Each user has a dedicated project which can be used for completing the workshop labs.  Enjoy!"

$requestBody = @()
$requestBody += @{
    from = ""
    op = "replace"
    path = "/accessLevel"
    value = @{
        msdnLicenseType = "enterprise"
        licensingSource = "msdn"
    }
}

1..$users | ForEach-Object {
    # Create User
    $emailId = ("user{0}@{1}" -f $_, $tenant)
    Write-Information ("Adding user {0}" -f $emailId)
    $user = az devops user add --email $emailId --license-type stakeholder --send-email-invite false --org $organization | ConvertFrom-Json

    # Set Access Level to Visual Studio Enterprise Subscriber

    # AzDO CLI does not use the https://vsaex.dev.azure.com service, so we have to resort to a raw Invoke-RestMethod

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json-patch+json")
    $basicAuthPair = ("not_needed_with_a_pat:{0}" -f $env:AZURE_DEVOPS_EXT_PAT)
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($basicAuthPair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $headers.Add("Authorization", "Basic $base64")

    $body = (ConvertTo-Json $requestBody)
    $uri = 'https://vsaex.dev.azure.com/' + $orgName + '/_apis/userentitlements/' + $user.id + '?api-version=5.1-preview.2'

    Write-Information ("Updating access level for user {0} to Visual Studio Enterprise Subscription..." -f $emailId)
    $response = Invoke-RestMethod -Uri $uri -Method 'PATCH' -Headers $headers -Body $body

    # TODO - Check response code


    # Create a Project
    $projectName = ("Project{0}" -f $_)
    $description = ("DevOps in a Day Workshop project for User {0}" -f $_)

    $project = az devops project list --org $organization --query "[?name == '$projectName']" | ConvertFrom-Json
    if(-not $project)
    {
        Write-Information "Creating project $projectName"
        az devops project create --name $projectName --description $description --org $organization --source-control git --output none
    }

    # Add user to Project Administrators
    Write-Information "Adding user $emailId to [$projectName]\Project Administrators"
    $projectAdministratorsDescriptor = (az devops security group list --org $organization --project $projectName --scope project --query "graphGroups[?displayName == 'Project Administrators']" | ConvertFrom-Json).descriptor
    az devops security group membership add --group-id $projectAdministratorsDescriptor --member-id $emailId --org $organization --output none
}