Clear-Host

$version="1.1.0"

Clear-Host
Write-Host -BackgroundColor DarkBlue "Installateur de la distribution mipy $version"
Get-Content .\ascii-art.ans
Start-Sleep -Seconds 2

Clear-Host
Write-Host -BackgroundColor DarkBlue "Installateur de la distribution mipy $version"
Write-Output "Voici tous les modules gérés par la distribution."
Write-Output "Les modules Langage et Editeur sont nécessaires. Le reste est optionel et vous sera demandé."
Get-Content .\doc\DOWNLOADS.txt
Pause
Function Test-CommandExists
{
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = "stop"
    try {if(Get-Command $command){"$command exists"}}
    Catch {"$command does not exist"}
    Finally {$ErrorActionPreference=$oldPreference}
}

function pyinstall() {
    Write-Host -ForegroundColor Blue "Installation de Python 3.11.5"
    $installer_url="https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe"
    Invoke-WebRequest -URI $installer_url -OutFile "tmp/python_installer.exe"
    tmp/python_installer.exe /passive InstallAllusers=1 AppendPath=1
    Pause
}

function vscinstall() {
    Write-Host -ForegroundColor Blue "Installation de Visual Studio Code"
    $installer_url="https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
    Invoke-WebRequest -URI $installer_url -OutFile "tmp/vscode_installer.exe"
    tmp/vscode_installer.exe /SILENT /ALLUSERS /NOCANCEL
}

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Langage > Python 3.11.5"
If(-not (Test-CommandExists "py")) {
    pyinstall
} Else {
    Write-Host -ForegroundColor Green "Une version de Python est déjà installée :"
    py -V
    $confirmation = Read-Host -Prompt "Installer Python 3.11.5 ? [écrire OUI en majuscules pour accepter, n'importe quoi d'autre pour annuler]"
    If($confirmation -eq "OUI") {
        pyinstall
    }
}

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Editeur > Visual Studio Code"
If(-not (Test-CommandExists "code")) {
    vscinstall
} Else {
    Write-Host -ForegroundColor Green "Visual Studio Code est déjà installé."
}
Pause

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Editeur > Extension Python"
$l = $(code --list-extensions)
If($l -notcontains "ms-python.python") {
    code --install-extension "ms-python.python"
} Else {
    Write-Host -ForegroundColor Green "L'extension Python est déjà installée."
}
Pause

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Langue > Paquets pip"
Write-Host -ForegroundColor DarkBlue "Voici les modules disponibles dans la distribution :"
ForEach($item in $(Get-ChildItem .\pip)) {
    Write-Host -NoNewline "$($item.Name) "
}
Write-Host "`n"
$modules = Read-Host -Prompt "Ecrivez les modules que vous souhaitez installer.`nSéparez chaque nom de module par une virgule.`nExemple : écrivez 'gui tui' si vous ne voulez que les modules gui et tui.`nSi vous voulez tous les modules, entrez *`n[Modules]"
$execute = $true
If($modules -ne "*") {
    $module_selections = $modules.Split(" ")
} ElseIf ($modules -eq "") {
    $execute = $false
} Else {
    $module_selections = Get-ChildItem .\pip
}
If($execute -eq $true) {
    ForEach($selected_module in $module_selections) {
        Clear-Host
        Write-Host -BackgroundColor DarkBlue "mipy $version > Langue > Paquets pip > $selected_module"
        If(Test-Path "pip/$selected_module") {
            Write-Host -ForegroundColor Green "Paquets à installer :"
            Get-Content "pip/$selected_module"
            Write-Output ""
            py -m pip install -r "pip/$selected_module"
        } else {
            Write-Host -ForegroundColor Red "Module $selected_module introuvable. Vous pouvez toujours installer des paquets individuels plus tard."
        }
        Start-Sleep -Seconds 1
    }
}

Clear-Host
Write-Host -ForegroundColor Green "mipy $version a été installé !"
Write-Host -ForegroundColor Blue "Voici quelques astuces pour vous aider :"
Write-Host -ForegroundColor Gray -NoNewline "Pour ouvrir un dossier de travail, utilisez "
Write-Host -ForegroundColor White -NoNewline "Visual Studio Code"
Write-Host -ForegroundColor Gray -NoNewline " ou utilisez la commande "
Write-Host -ForegroundColor Magenta -NoNewline "code chemin/du/dossier"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "Python inclut également l'éditeur "
Write-Host -ForegroundColor White -NoNewline "IDLE"
Write-Host -ForegroundColor Gray -NoNewline ", que vous pouvez soit lancer directement soit avec la commande "
Write-Host -ForegroundColor Magenta -NoNewline "py -m idlelib chemin/du/fichier"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "Pour lancer un fichier Python depuis VS Code, utilisez "
Write-Host -ForegroundColor White -NoNewline "fn + f5 (ou f5 si votre ordinateur n'a pas de touche fn)"
Write-Host -ForegroundColor Gray -NoNewline " ou la commande "
Write-Host -ForegroundColor Magenta -NoNewline "py chemin/du/fichier"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "Si vous voulez installer des paquets Python, utilisez "
Write-Host -ForegroundColor Magenta -NoNewline "pip install nom_du_paquet"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "Si vous voulez mettre à jour des paquets Python, utilisez "
Write-Host -ForegroundColor Magenta -NoNewline "pip install --upgrade nom_du_paquet"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "Si vous voulez supprimer des paquets Python, utilisez "
Write-Host -ForegroundColor Magenta -NoNewline "pip uninstall nom_du_paquet"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "Si vous voulez voir tous les paquets Python installés, utilisez "
Write-Host -ForegroundColor Magenta -NoNewline "pip list"
Write-Host -ForegroundColor Gray "."

Pause