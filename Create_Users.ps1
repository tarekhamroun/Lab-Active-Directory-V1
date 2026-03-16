# =============================================================
# Script : Création automatique des utilisateurs AD
# Auteur  : Tarek Hamroun Lab Active Directory V1
# =============================================================
# Prérequis : fichier names.txt dans le même dossier
# Format names.txt : "Prénom Nom" (une ligne par utilisateur)
#
# Note : le script crée les utilisateurs directement dans l'OU _USERS.
# Après exécution, les comptes ont été déplacés manuellement
# dans la sous-OU "Accounts" via la console Active Directory Users and Computers.
# =============================================================

$PASSWORD_FOR_USERS   = "TonMotDePasse"
$USER_FIRST_LAST_LIST = Get-Content .\names.txt

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

foreach ($n in $USER_FIRST_LAST_LIST) {
    $first    = $n.Split(" ")[0].ToLower()
    $last     = $n.Split(" ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)".ToLower()

    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan

    New-AdUser -AccountPassword $password `
               -GivenName $first `
               -Surname $last `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
               -Enabled $true
}