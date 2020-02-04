param(
    [Parameter(Mandatory=$true)]
    [string]$tenantName,
    [int]$users = 24
)

# Pre-requisites:
# 1. Azure DevOps CLI must be installed.
# 2. A personal access token must be provided which has access to all organizations.
# 3. Azure DevOps organizations must exist.

# Known Limitations:
# - You must define the list of organizations below.

$DebugPreference = "Continue"

if(-not (Get-Command "az" -ErrorAction SilentlyContinue)) 
{
    throw "az command is not found.  Please check that the Azure CLI is installed and in the path."
}

if(-not $env:AZURE_DEVOPS_EXT_PAT)
{
    throw "Please set `$env:AZURE_DEVOPS_EXT_PAT environment variable."
}

$usersPerOrg = 5
$userNumber = 0

$organizations = @(
    ("https://dev.azure.com/{0}-A" -f $tenantName),
    ("https://dev.azure.com/{0}-B" -f $tenantName),
    ("https://dev.azure.com/{0}-C" -f $tenantName),
    ("https://dev.azure.com/{0}-D" -f $tenantName),
    ("https://dev.azure.com/{0}-E" -f $tenantName)
)

$tenant = "{0}.onmicrosoft.com" -f $tenantName

$gitWorkingDir = "C:\GitClone"
New-Item -ItemType Directory -Force -Path $gitWorkingDir | Out-Null

function Create-LabEnvironment($userNumber, $organization)
{
    $emailAddress = "user{0}@{1}" -f $userNumber, $tenant

    # Add user to the organization...
    Write-Debug ""
    Write-Debug ("Adding user {0} to organization {1}..." -f $emailAddress, $organization)
    $user = az devops user add --email $emailAddress --license-type express --send-email-invite false --org $organization | ConvertFrom-Json
    Write-Debug ("... done, {0} added to {1}" -f $user.user.mailAddress, $organization)

    # Create a project for the user...
    $projectName = ("Project{0}" -f $userNumber)
    $description = ("DevOps in a Day Workshop project for User {0} ({1})" -f $userNumber, $emailAddress)

    $project = az devops project list --org $organization --query "[?name == '$projectName']" | ConvertFrom-Json
    if(-not $project)
    {
        Write-Debug "Creating project $projectName in organization $organization..."
        az devops project create --name $projectName --description $description --org $organization --source-control git --output none
        Write-Debug "... done."
    }

    # Add user to Project Administrators...
    Write-Debug "Adding user $emailAddress to [$projectName]\Project Administrators..."
    $projectAdministratorsDescriptor = (az devops security group list --org $organization --project $projectName --scope project --query "graphGroups[?displayName == 'Project Administrators']" | ConvertFrom-Json).descriptor
    az devops security group membership add --group-id $projectAdministratorsDescriptor --member-id $emailAddress --org $organization --output none
    Write-Debug "... done."

    # Get repo
    $repo = az repos list --org $organization --project $projectName | ConvertFrom-Json
    $repo.remoteUrl -match "\/\/(?'org'[^\@]*)" | Out-Null
    $remoteUrlOrg = $Matches['org']

    $remoteUrl = $repo.remoteUrl -replace ("https://{0}" -f $remoteUrlOrg),("https://NOT_NEEDED_FOR_PAT:{0}" -f $env:AZURE_DEVOPS_EXT_PAT)
    
    # Clone repo
    Push-Location
    Set-Location $gitWorkingDir

    if(Test-Path $repo.name){
        Write-Debug "Removing previous repo..."
        Remove-Item -LiteralPath $repo.name -Force -Recurse
        Write-Debug "... done."
    }

    git clone $remoteUrl $repo.name

    # Change location to the cloned repo
    Set-Location $repo.name

    # Copy template repo
    Copy-Item -Path "$PSScriptRoot\repo\*" -Destination . -Recurse -Force
    
    # Initial Commit
    git config user.name "MOD Administrator"
    git config user.email ("admin@{0}" -f $tenant)
    git add .
    git commit -m "initial commit"
    git push

    Pop-Location    
}

# TODO - Refactor users, usersPerOrg to leverage array of organizations.
for($i=0; $i -le ($users % $usersPerOrg); $i++)
{
    $organization = $organizations[$i]

    for($j=1; $j -le $usersPerOrg; $j++)
    {
        $userNumber++

        if($userNumber -gt $users) {
            break;
        }

        Create-LabEnvironment -userNumber $userNumber -tenant $tenant -organization $organization
    }
}