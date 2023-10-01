<# This script creates random users using dictionary lists and an org.json file to simulate a corporate structure. It will set randomly generated passwords for each user
and save them to an output file, so that you can log in as any of those users when testing GPO's or anything else. Please do not use in or try to adapt for a production environment. #>


param (
    [int]$NumberOfUsers = 100,  # Specify the number of users to create
    [string]$OutputFilePath = "$env:USERPROFILE\Downloads\AD Lab\Passwords.txt", # Specify the output file path for user and password list
    [string]$FirstNameFilePath = "$env:USERPROFILE\Downloads\AD Lab\1000_First_Names.txt", # Specify file path to dictionary list
    [string]$LastNameFilePath = "$env:USERPROFILE\Downloads\AD Lab\1000_Last_Names.txt", # Specify file path to dictionary list
    [string]$OrgFilePath = "$env:USERPROFILE\Downloads\AD Lab\Org.json", # Specify file path to organization json
    [string]$domain = "", # Specify your domain (This will be used when setting user email addresses)
    [string]$OUDistinguishedName = "OU=User Accounts,DC=domain,DC=com", # Specify target OU path
    [int]$PasswordLength = 32  # Specify the length of the randomly generated password
)

# Initialize Arrays
$UserInformation = @()
$FirstNames = @()
$LastNames = @()
$OrgStructure = @()


# Load dictionary files into arrays
$FirstNames = Get-Content $FirstNameFilePath
$LastNames = Get-Content $LastNameFilePath
$OrgStructure = Get-Content $OrgFilePath | ConvertFrom-Json

# Create an associative array to map job titles to departments
$jobTitleToDepartmentMap = @{}
foreach ($department in $OrgStructure.Departments) {
    foreach ($jobTitle in $department.JobTitles) {
        $jobTitleToDepartmentMap[$jobTitle] = $department.Name
    }
}

# Create Active Directory users
for ($i = 1; $i -le $NumberOfUsers; $i++) {
    # Generate random data from dictionary lists
    $RandomFirstName = $FirstNames | Get-Random
    $RandomLastName = $LastNames | Get-Random
    $RandomDepartment = ($OrgStructure.Departments | Get-Random).Name
    $RandomJobTitle = ($OrgStructure.Departments | Where-Object { $_.Name -eq $RandomDepartment }).JobTitles | Get-Random

    # Structured values
    $Email = ($RandomFirstName.Substring(0, 1).ToLower() + $RandomLastName.ToLower() -replace '\s','' -replace '[^a-zA-Z0-9]','') + "@$domain"
    $SamAccountName = ($RandomFirstName.Substring(0, 1).ToLower() + $RandomLastName.ToLower())

    # Generate a random password
    $Password = -join (1..$PasswordLength | ForEach-Object { [char](Get-Random -Minimum 33 -Maximum 127) })

    # Create the user in the specified OU with lowercase SamAccountName, enabled, and set the password
    New-ADUser -Name "$RandomFirstName $RandomLastName" `
               -GivenName $RandomFirstName `
               -Surname $RandomLastName `
               -DisplayName "$RandomFirstName $RandomLastName" `
               -SamAccountName $SamAccountName `
               -EmailAddress $Email `
               -Department $RandomDepartment `
               -Title $RandomJobTitle `
               -Description $RandomJobTitle `
               -Path $OUDistinguishedName `
               -AccountPassword (ConvertTo-SecureString -AsPlainText $Password -Force) `
               -Enabled $true
    # Store user information in an array
    $UserInformation += "${SamAccountName}:${Password}"
}

# Save user information to the output file
Write-Host Username and Password List saved to $OutputFilePath -ForegroundColor Green
$UserInformation | Out-File -FilePath $OutputFilePath
