$DeadDNSRecords = @("khsz-dc.kherson-shipyard.com.", "khsz-dc5.kherson-shipyard.com." , "khsz-dc2.kherson-shipyard.com." ,"rdp.kherson-shipyard.com.")
$DeadIpAdresses = @("172.22.33.102","172.22.33.103")
$DNSZones = @(“_msdcs.kherson-shipyard.com”,“kherson-shipyard.com”)


foreach ($dnszone in $DNSZones)
    {
    $dnsrecords = Get-DnsServerResourceRecord -ZoneName $dnszone
    foreach ($i in $dnsrecords)
        { 
            foreach ($ip in $DeadIpAdresses)
            {
                if ($i.RecordData.IPv4Address -eq $ip)
                    {
                        Remove-DnsServerResourceRecord -ZoneName $dnszone -InputObject $i -Force
                        
                    }
            }
            foreach ($dns in $DeadDNSRecords)
            {
                if (($dns -eq $i.RecordData.NameServer) -or ($dns -eq $i.RecordData.DomainName))
                    {
                        Remove-DnsServerResourceRecord -ZoneName $dnszone -InputObject $i -Force
                        
                    }
            }
        
        }
    }