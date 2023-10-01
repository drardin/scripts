#Static Variables
$pwdExpireDays = 30 # How many days until password expires, in order to be flagged

while ($true) {
    $UN = Read-Host "Enter Username, SID, or GUID (Use Ctrl-C to Exit)"

    if (-not (Get-ADUser -Filter {SamAccountName -eq $UN})) {
        Write-Host "User not found. Please try again." -ForegroundColor Red
        continue  # Restart the loop if the username doesn't exist
    }

    $user = Get-ADUser -Identity $UN -Properties Name,Title,SamAccountName,homeDrive,homeDirectory,Manager,MemberOf,msDS-UserPasswordExpiryTimeComputed,PasswordNeverExpires,DistinguishedName

    # Check if user was found
    if ($user) {
        Write-Host "User Info:"
        $ou = ($user.DistinguishedName -split ',').Where({$_ -like 'OU=*'}, 'First') -replace 'OU='  # Get the first OU in the DistinguishedName
        $user | Select-Object Name, Title, SamAccountName, SID, @{Name='Home Drive'; Expression={$_.homeDrive}}, @{Name='Home Directory'; Expression={$_.homeDirectory}}, @{Name='Parent OU'; Expression={$ou}}

        Write-Host "Login Info:"
        $passwordExpiryDate = if ($user.PasswordNeverExpires) { "Password Never Expires" } else { [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed") }
        $daysRemaining = if ($user.PasswordNeverExpires) { "N/A" } else { ($passwordExpiryDate - (Get-Date)).Days }

        $user | Select-Object @{Name='Locked Out'; Expression={$_.lockedout}}, @{Name='Password Expired'; Expression={$_.passwordexpired}}, @{Name='Password Expiry Date'; Expression={$passwordExpiryDate}}, @{Name='Days Until Password Expires'; Expression={$daysRemaining}}, @{Name='Password Never Expires'; Expression={$user.PasswordNeverExpires}}, @{Name='Last Logon Date'; Expression={$_.lastlogondate}}, @{Name='Logon Count'; Expression={$_.logoncount}}

        Write-Host "Office Info:"
        $user | Select-Object Office, @{Name='Phone Number'; Expression={$_.telephoneNumber}}, Department, @{Name='Manager'; Expression={(Get-ADUser $_.Manager).Name}}

        Write-Host "Group Membership Info:"
        $user.MemberOf | ForEach-Object {
            $groupName = (Get-ADGroup $_).Name
            Write-Host $groupName
        }

        Write-Host "" # Acts as a separator

        $showImportant = $false  # Initialize showImportant variable

        # Check for any flagged fields
        if ($user.msExchHideFromAddressLists -or $user.lockedout -or $user.passwordexpired -or $user.PasswordNeverExpires -or [string]::IsNullOrEmpty($user.telephoneNumber) -or [string]::IsNullOrEmpty($user.homeDrive) -or [string]::IsNullOrEmpty($user.homeDirectory) -or ($daysRemaining -ge 0 -and $daysRemaining -le $pwdExpireDays)) {
            $showImportant = $true
        }

        # Generate Important section, if any flags exist
        if ($showImportant) {
            Write-Host "Important Info:" -ForegroundColor Yellow
            if ($user.msExchHideFromAddressLists) {
                Write-Host "GAL: Hidden" -ForegroundColor Red
            }
            if ($user.lockedout) {
                Write-Host "Locked Out: $($user.lockedout)" -ForegroundColor Red
            }
            if ($user.passwordexpired) {
                Write-Host "Password Expired: $($user.passwordexpired)" -ForegroundColor Red
            }
            if ($user.PasswordNeverExpires) {
                Write-Host "Password Never Expires: $($user.PasswordNeverExpires)" -ForegroundColor Red
            }
            if ([string]::IsNullOrEmpty($user.telephoneNumber)) {
                Write-Host "Phone Number: Not Set" -ForegroundColor Red
            }
            if ([string]::IsNullOrEmpty($user.homeDrive)) {
                Write-Host "Home Drive: Not Set" -ForegroundColor Red
            }
            if ([string]::IsNullOrEmpty($user.homeDirectory)) {
                Write-Host "Home Directory: Not Set" -ForegroundColor Red
            }
            if ($daysRemaining -ge 0 -and $daysRemaining -le $pwdExpireDays) {
                Write-Host "Days Until Password Expires: $daysRemaining days" -ForegroundColor Red
            }
        }
    }   
    Write-Host "" # Acts as a separator
}
