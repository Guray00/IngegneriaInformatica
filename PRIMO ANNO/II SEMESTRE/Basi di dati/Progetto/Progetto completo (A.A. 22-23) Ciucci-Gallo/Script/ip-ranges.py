def generate():
    """
    with open('asn-country-ipv4-num.csv', 'r') as file_in, open('ip-ranges.sql', 'w') as file_out:
        for line_in in file_in:
            # Ip Start, Ip End, Country code
            ip_start, ip_end, country_code = line_in.split(',')
            ip_start = ip_start.strip()
            ip_end = ip_end.strip()
            country_code = country_code.strip()
            assert len(country_code) == 2
            country_code = country_code.upper()
            line = f'CALL `IpRangeInserisciAdessoFidato`({ip_start}, {ip_end}, \'{country_code}\', FALSE);\n'
            file_out.write(line)
    """
    delta_max = 0
    with open('asn-country-ipv4-num.csv', 'r') as file_in, open('ip-ranges.sql', 'w') as file_out:
        sql = 'REPLACE INTO `IPRange` (`Paese`, `Inizio`, `Fine`, `DataInizio`) VALUES\n'
        old_line = ''
        file_out.write(sql)
        for line_in in file_in:
            # Ip Start, Ip End, Country code
            ip_start, ip_end, country_code = line_in.split(',')
            ip_start = int(ip_start.strip())
            ip_end = int(ip_end.strip())
            delta_max = max(ip_end - ip_start, delta_max)
            country_code = country_code.strip()
            assert len(country_code) == 2
            country_code = country_code.upper()
            
            if ip_end - ip_start <= 256:
                continue

            this_line = f'(\'{country_code}\', {ip_start}, {ip_end}, CURRENT_TIMESTAMP - INTERVAL 20 DAY)'
            if len(old_line) == 0:
                # First time we write, no comma
                old_line = '\n\t' + this_line
            else:
                old_line = ',\n\t' + this_line
            file_out.write(old_line)
        file_out.write(';\n\nCALL `VisualizzazoniGiornaliereFullReBuild`();\n')
        # print(delta_max)
                

if __name__ == '__main__':
    generate()