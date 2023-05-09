# Installa il modulo VMware.PowerCLI se non è già installato
if (-not (Get-Module -Name VMware.PowerCLI -ListAvailable)) {
        Install-Module -Name VMware.PowerCLI -Scope CurrentUser -Force
    }
    if (-not (Get-Module -Name VMware.VimAutomation.Core -ListAvailable)){
        Install-Module -Name VMware.VimAutomation.Core -Scope CurrentUser -Force
    }
    
    # Importa il modulo VMware.PowerCLI
    Import-Module -Name VMware.PowerCLI
    Import-Module -Name VMware.VimAutomation.Core
    
    # Configurazione PowerCLI
    Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    
    # Import delle variabili dall'ambiente GitLab
    $GOVC_URL = $env:GOVC_URL
    $GOVC_USERNAME = $env:GOVC_USERNAME
    $GOVC_PASSWORD_BASE64 = $env:GOVC_PASSWORD_BASE64
    
    # Decodifica della password base64
    $GOVC_PASSWORD = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($GOVC_PASSWORD_BASE64))
    
    # Connetti a vCenter
    Connect-VIServer -Server "$GOVC_URL" -User "$GOVC_USERNAME" -Password "$GOVC_PASSWORD"
    
    # Ottieni l'elenco dei template nella cartella 
    $Templates = Get-Folder -Location "Templates" -Name "Versioning_Template" | Get-Template | Where-Object {$_.Name.StartsWith("ubuntu2004_template_")}
    
    
    # Ordina i template per data e mantieni solo i 5 più recenti
    $TemplatesToKeep = $Templates | Sort-Object {[DateTime]::ParseExact($_.Name.Split("_")[-2], "ddMMyyyy", $null)} | Select-Object -Last 5
    
    # Rimuovi i vecchi template 
    $Templates | Where-Object {$_.Name -notin $TemplatesToKeep.Name} | Remove-Template -Confirm:$false 
    
    # Disconnettiti da vSphere 
    Disconnect-VIServer -Confirm:$false
    