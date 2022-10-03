Import-Module ActiveDirectory

function Show-Menu
{
     param (
           [string]$Title = 'My Menu'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Нажми '1' заблокировать учетную запись."
     Write-Host "2: Нажми '2' разблокироать учетную запись."
     Write-Host "Q: Нажми 'Q' чтобы выйти."
}
do
{
     Show-Menu
     $input = Read-Host "Выбери опцию:"
     switch ($input)
     {
           '1' {
                cls
                'Заблокирование учетной записи #1'
                Get-ADUser -Filter 'SamAccountName -eq "ArtSoft1"' -SearchBase "DC=chsz,DC=local" | Disable-ADAccount
           } '2' {
                cls
                'Разблокирование учетной записи #2'
                Get-ADUser -Filter 'SamAccountName -eq "ArtSoft1"' -SearchBase "DC=chsz,DC=local" | Enable-ADAccount
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')