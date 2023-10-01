# Specify the path to the text files containing the lists of apps to uninstall and install
$uninstallListFile = "$env:USERPROFILE\Documents\Uninstall-Apps.txt"
$installListFile = "$env:USERPROFILE\Documents\Install-Apps.txt"

# Install Winget if not installed
$wingetInstalled = Get-Command winget -ErrorAction SilentlyContinue

if (-not $wingetInstalled) {
    Write-Host "Installing Windows Package Manager (winget)..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

# Uninstall apps from the uninstall list
if (Test-Path -Path $uninstallListFile) {
    $appsToUninstall = Get-Content $uninstallListFile
    foreach ($app in $appsToUninstall) {
        Write-Host "Uninstalling $app..."
        # Use winget to uninstall the app
        winget uninstall --ID $app
    }
    Write-Host "Uninstall process completed."
}
else {
    Write-Host "The specified uninstall app list file does not exist: $uninstallListFile"
}

# Install apps from the install list
if (Test-Path -Path $installListFile) {
    $appsToInstall = Get-Content $installListFile
    foreach ($app in $appsToInstall) {
        Write-Host "Installing $app..."
        # Use winget to install the app
        winget install --ID $app
    }
    Write-Host "Installation process completed."
}
else {
    Write-Host "The specified install app list file does not exist: $installListFile"
}
