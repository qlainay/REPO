Import-Module ActiveDirectory
$Serveur = "controlleur.de.domaineFQDN"
$Groupe  = "nom_du_groupeE"
$list_user = get-content "C:\chemin\adduseradgroup.csv"

foreach ($user in $list_user){
    Add-ADGroupMember -Server $Serveur -Identity $Groupe -Confirm:$false
}