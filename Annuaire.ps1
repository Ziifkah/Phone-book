#Annuaire powershell

#Variables
$BDD = "C:\ScriptAnnuaire\DorianAnnuaireScript.csv"
$CancelBDDremoveOk = "n"

#Fonctions

#Fonction Menu et selection de mode BDD
function Show-Menu {
    param (
        [string]$Title = 'MENU'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host "Entrer BDD: '1'"
    Write-Host "Ecrire BDD: '2'"
    Write-Host "Créer BDD: '3'"
    Write-Host "Supprimer BDD: '4'"
    Write-Host "Quitter: 'Q'"
    Write-Host "======================================"
    $selection = Read-Host "Selection"
    switch ($selection)

    {

        '1' {
            if (Test-Path -Path $BDD -PathType Leaf) {
                Clear-Host
                Write-Host "Ok! Ouverture de la BDD"
                Start-Sleep 1
                ApercuBDD
            }
            else {
                Clear-Host
                Write-Host "Pas de BDD!"
                Start-Sleep 2
                Show-Menu
            }

        }
        '2' {
            if (Test-Path -Path $BDD -PathType Leaf) {
                AjouterBDD
            }
            else {
                Clear-Host
                Write-Host "Pas de BDD!"
                Start-Sleep 2
                Show-Menu
            }

        }

        '3' {
            Clear-Host
            if (Test-Path -Path $BDD -PathType Leaf) {
                Write-Host "La BDD est déjà présente!"
                Start-Sleep 2
                Show-Menu
            }
            else {
                Clear-Host
                $null = New-Item $BDD -ItemType File
                Write-Host "Ok! Création de la BDD."
                Add-content -path $BDD -Value "Nom,Prenom,Numero,Adresse"
                Start-Sleep 2
                Show-Menu
            }
        }

        '4' {
            Clear-Host
            $CancelBDDremove = Read-Host "Confirmer la suppression de la BDD ? (y or n)"
            if (-not($CancelBDDremove -eq $CancelBDDremoveOk)) {
                ConfirmBDDremove
            }
            else {
                Clear-Host
                Write-Host "Ok! annulation de la supression!"
                Start-Sleep 2
                Show-Menu
            }
        }
        'q' {
            return
        }
    }
}

#Fonction supression de la BDD
function ConfirmBDDremove {
    if (Test-Path -Path $BDD -PathType Leaf) {
        Clear-Host
        Remove-Item -Path $BDD -Recurse
        Write-Host "Ok! Supression de la BDD"
        Start-Sleep 2
        Show-Menu
    }
    else {
        Clear-Host
        Write-Host "Pas de BDD a supprimer!"
        Start-Sleep 2
        Show-Menu
    }
}

#Fonction apercu de la BDD
function ApercuBDD {
    Clear-Host
    $ApercuBDD = Read-Host "Voulez-vous un apercu de la BDD ? (y or n)"
    #Clear-Host
    if ($ApercuBDD -eq "y") {
        $CSVBDD = Import-CSV -Path $BDD -Delimiter ","
        $CSVBDD | Format-Table
        Pause
        Clear-Host
        RechercheBDD
    }
    else {
        Clear-Host
        RechercheBDD
    }
}

#Fonction recherche dans la BDD
function RechercheBDD {
    Clear-Host
    $RechercheDeUserBDD = Read-Host "Que rechercher ? (Nom,Prenom,Numero,Adresse)"
    Select-String -Path $BDD -Pattern $RechercheDeUserBDD | Select-Object -ExpandProperty Line
    Pause
    Show-Menu
}

#Fonction ajouter dans la BDD
function AjouterBDD {
    Clear-Host
    $NewLineBDDnom = Read-Host "Nom ?"
    $NewLineBDDprenom = Read-Host "Prenom ?"
    $NewLineBDDnumero = Read-Host "Numero ?"
    $NewLineBDDadresse = Read-Host "Adresse ?"
    $ConfirmBDDajout = Read-Host "Confirmer l'ajout des informations ? (y or n)"
    if ($ConfirmBDDajout -eq "y") {
        Clear-Host
        Add-content -path $BDD -Value "$NewLineBDDnom,$NewLineBDDprenom,$NewLineBDDnumero,$NewLineBDDadresse"
        Write-Host "Ok! ajout des informations dans la BDD"
        Start-Sleep 2
        Show-Menu
    }
    else {
        Clear-Host
        Write-Host "Ok! retour au menu"
        Start-sleep 2
        Show-Menu
    }
}

Show-Menu

