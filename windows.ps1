Clear-Host

$version="1.0.2"

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version distribution installer"
Get-Content .\ascii-art.ans
Start-Sleep -Seconds 2

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version distribution installer"
Write-Output "Here is every module that is available in the distribution."
Write-Output "The Language and Editor modules are mandatory. Every other module is optional and will be prompted to you."
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
    Write-Host -ForegroundColor Blue "Installing Python 3.11.5"
    $installer_url="https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe"
    Invoke-WebRequest -URI $installer_url -OutFile "tmp/python_installer.exe"
    tmp/python_installer.exe /passive AppendPath=1
    Pause
}

function vscinstall() {
    Write-Host -ForegroundColor Blue "Installing Visual Studio Code"
    $installer_url="https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
    Invoke-WebRequest -URI $installer_url -OutFile "tmp/vscode_installer.exe"
    tmp/vscode_installer.exe /SILENT /NOCANCEL
}

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Language > Python 3.11.5"
If(-not (Test-CommandExists "py")) {
    pyinstall
} Else {
    Write-Host -ForegroundColor Green "A version of Python is already installed:"
    py -V
    $confirmation = Read-Host -Prompt "Would you like to install Python 3.11.5?`n[type YES (case-sensitive) to confirm, anything else if not]"
    If($confirmation -eq "YES") {
        pyinstall
    }
}

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Editor > Visual Studio Code"
If(-not (Test-CommandExists "code")) {
    vscinstall
} Else {
    Write-Host -ForegroundColor Green "Visual Studio Code is already installed."
}
Pause

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Editor > Python extension"
$l = $(code --list-extensions)
If($l -notcontains "ms-python.python") {
    code --install-extension "ms-python.python"
} Else {
    Write-Host -ForegroundColor Green "Python for VSC is already installed."
}
Pause

Clear-Host
Write-Host -BackgroundColor DarkBlue "mipy $version > Language > pip libraries"
Write-Host -ForegroundColor DarkBlue "Here are the available modules:"
ForEach($item in $(Get-ChildItem .\pip)) {
    Write-Host -NoNewline "$($item.Name) "
}
Write-Host "`n"
$modules = Read-Host -Prompt "Please type in all of the modules that you would like to install.`nYou must separate them using a space.`nExample: type 'gui tui' if you only want the gui and tui modules.`nIf you want all modules, type *`n[Modules]"
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
        Write-Host -BackgroundColor DarkBlue "mipy $version > Language > pip libraries > $selected_module"
        If(Test-Path "pip/$selected_module") {
            Write-Host -ForegroundColor Blue "Libraries to install:"
            Get-Content "pip/$selected_module"
            Write-Output ""
            py -m pip install -r "pip/$selected_module"
            Write-Host -ForegroundColor Green "Module $selected_module installed!"
        } else {
            Write-Host -ForegroundColor Red "Module $selected_module wasn't found. You can always install individual libraries later."
        }
        Start-Sleep -Seconds 1
    }
}

Clear-Host
Write-Host -ForegroundColor Green "mipy $version was successfully installed!"
Write-Host -ForegroundColor Blue "Here are some tips to get you started:"
Write-Host -ForegroundColor Gray -NoNewline "To open a folder, use "
Write-Host -ForegroundColor White -NoNewline "Visual Studio Code"
Write-Host -ForegroundColor Gray -NoNewline " or run the terminal command "
Write-Host -ForegroundColor Magenta -NoNewline "code path/to/workspace"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "Python also bundles the "
Write-Host -ForegroundColor White -NoNewline "IDLE"
Write-Host -ForegroundColor Gray -NoNewline " editor, which you can run directly or using the command "
Write-Host -ForegroundColor Magenta -NoNewline "python -m idlelib path/to/script"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "To run a Python file from VS Code, use "
Write-Host -ForegroundColor White -NoNewline "fn + f5 (or f5 if your computer doesn't have an fn key)"
Write-Host -ForegroundColor Gray -NoNewline " or from the command line "
Write-Host -ForegroundColor Magenta -NoNewline "py path/to/file"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "If you want to install Python libraries, use "
Write-Host -ForegroundColor Magenta -NoNewline "pip install name_of_library"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "If you want to upgrade Python libraries, use "
Write-Host -ForegroundColor Magenta -NoNewline "pip install --upgrade name_of_library"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "If you want to remove Python libraries, use "
Write-Host -ForegroundColor Magenta -NoNewline "pip uninstall name_of_library"
Write-Host -ForegroundColor Gray "."

Write-Host -ForegroundColor Gray -NoNewline "If you want to see all Python libraries, use "
Write-Host -ForegroundColor Magenta -NoNewline "pip list"
Write-Host -ForegroundColor Gray "."

Pause