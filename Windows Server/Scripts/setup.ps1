$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
$profile01 = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profile01.Name -NetworkCategory Private

#Install PS Windows Update Module

#Get-PackageProvider -name nuget -force
#Install-Module PSWindowsUpdate -confirm:$false -force
#Get-WindowsUpdate -MicrosoftUpdate -install -IgnoreUserInput -acceptall -AutoReboot | Out-File -filepath 'c:\windowsupdate.log' -append

#WinRM Configure
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{UseHttps="false"}'
winrm set winrm/config/client '@{TrustedHosts="10.154.9.111"}'

Enable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

# Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

