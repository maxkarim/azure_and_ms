$port_range1 = @(53,88,389,636,135,445)
$port_range2 = @(389,636)
$port_range_start = 49152
$ip_dst1 = @("172.29.4.63","172.29.4.64","172.29.40.10","172.29.4.34","172.29.4.47")
$ip_dst2 = @("172.29.4.55","172.29.4.59")

New-Item "\\172.22.98.24\LogonUsers\DC ports\$env:COMPUTERNAME.txt" -Type file -Force
Add-Content -PassThru "\\172.22.98.24\LogonUsers\DC ports\$env:COMPUTERNAME.txt" "Check 53,88,389,636,135,445 on 172.29.4.63,172.29.4.64,172.29.40.10,172.29.4.34,172.29.4.47"
foreach ($ip in $ip_dst1)
{
    foreach ($port in $port_range1)
    {
        $S = Test-NetConnection -Port $port -ComputerName $ip -WarningAction SilentlyContinue
        Write-Host $S.RemoteAddress $S.RemotePort $S.TcpTestSucceeded
        [string]$result = [string]$S.RemoteAddress +" "+ [string]$S.RemotePort +" " +[string]$S.TcpTestSucceeded
        Add-Content -PassThru "\\172.22.98.24\LogonUsers\DC ports\$env:COMPUTERNAME.txt" "$result"
    }
}


Add-Content -PassThru "\\172.22.98.24\LogonUsers\DC ports\$env:COMPUTERNAME.txt" "Check 49152-65535 on 172.29.4.63,172.29.4.64,172.29.40.10,172.29.4.34,172.29.4.47"
Do { 
    foreach ($ip in $ip_dst1)
    {
        $S = Test-NetConnection -Port $port_range_start -ComputerName $ip -WarningAction SilentlyContinue
        Write-Host $S.RemoteAddress $S.RemotePort $S.TcpTestSucceeded
        [string]$result = [string]$S.RemoteAddress +" "+ [string]$S.RemotePort +" " +[string]$S.TcpTestSucceeded
        Add-Content -PassThru "\\172.22.98.24\LogonUsers\DC ports\$env:COMPUTERNAME.txt" "$result"
        $port_range_start++
    }
   } 
   while($port_range_start -ne 65535)


Add-Content -PassThru "\\172.22.98.24\LogonUsers\DC ports\$env:COMPUTERNAME.txt" "Check 389,636 on 172.29.4.55,172.29.4.59"
foreach ($ip in $ip_dst2)
{
    foreach ($port in $port_range2)
    {
        $S = Test-NetConnection -Port $port -ComputerName $ip -WarningAction SilentlyContinue
        [string]$result = [string]$S.RemoteAddress +" "+ [string]$S.RemotePort +" " +[string]$S.TcpTestSucceeded
		Add-Content -PassThru "\\172.22.98.24\LogonUsers\DC ports\$env:COMPUTERNAME.txt" "$result"
    }
}