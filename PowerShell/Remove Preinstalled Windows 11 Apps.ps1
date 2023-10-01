# This script uninstalls all of the pre-installed Microsoft apps that come pre-installed in Windows 11.
# Uninstalling all of these apps can potentially cause issues, though from my experience, Windows re-installs what it determines to be critical or prevents uninstallation
# Please exclude apps from this list that you want to retain as some of these can not easily be reinstalled

$appsToUninstall = @(
    "Clipchamp.Clipchamp_yxz26nhyzhsrt",
    "Microsoft.549981C3F5F10_8wekyb3d8bbwe",
    "Microsoft.BingNews_8wekyb3d8bbwe",
    "Microsoft.GamingApp_8wekyb3d8bbwe",
    "Microsoft.GetHelp_8wekyb3d8bbwe",
    "Microsoft.Getstarted_8wekyb3d8bbwe",
    "Microsoft.HEIFImageExtension_8wekyb3d8bbwe",
    "Microsoft.HEVCVideoExtension_8wekyb3d8bbwe",
    "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
    "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe",
    "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
    "Microsoft.Paint_8wekyb3d8bbwe",
    "Microsoft.People_8wekyb3d8bbwe",
    "Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe",
    "Microsoft.RawImageExtension_8wekyb3d8bbwe",
    "Microsoft.ScreenSketch_8wekyb3d8bbwe",
    "Microsoft.StorePurchaseApp_8wekyb3d8bbwe",
    "Microsoft.Todos_8wekyb3d8bbwe",
    "Microsoft.VP9VideoExtensions_8wekyb3d8bbwe",
    "Microsoft.WebMediaExtensions_8wekyb3d8bbwe",
    "Microsoft.WebpImageExtension_8wekyb3d8bbwe",
    "Microsoft.Windows.Photos_8wekyb3d8bbwe",
    "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
    "Microsoft.WindowsCalculator_8wekyb3d8bbwe",
    "Microsoft.WindowsCamera_8wekyb3d8bbwe",
    "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
    "Microsoft.WindowsMaps_8wekyb3d8bbwe",
    "Microsoft.WindowsNotepad_8wekyb3d8bbwe",
    "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe",
    "Microsoft.WindowsStore_8wekyb3d8bbwe",
    "Microsoft.Xbox.TCUI_8wekyb3d8bbwe",
    "Microsoft.XboxGameOverlay_8wekyb3d8bbwe",
    "Microsoft.XboxGamingOverlay_8wekyb3d8bbwe",
    "Microsoft.XboxIdentityProvider_8wekyb3d8bbwe",
    "Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe",
    "Microsoft.YourPhone_8wekyb3d8bbwe",
    "Microsoft.ZuneMusic_8wekyb3d8bbwe",
    "Microsoft.ZuneVideo_8wekyb3d8bbwe",
    "MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe",
    "MicrosoftTeams_8wekyb3d8bbwe",
    "MicrosoftWindows.Client.WebExperience_cw5n1h2txyewy",
    "microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
    "{AF47B488-9780-4AB5-A97E-762E28013CA6}",
    "Microsoft.OneDrive"
)

foreach ($app in $appsToUninstall) {
    Write-Output "Uninstalling $app"
    winget uninstall $app -q
}

Write-Output "Uninstallation complete." -ForegroundColor Green
