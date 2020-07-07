New-ACMEIdentifier -Dns plato.emptool.com                   -Alias plato_dns
New-ACMEIdentifier -Dns plato-trading-bot.plato.emptool.com -Alias plato_trading_bot_plato_dns
New-ACMEIdentifier -Dns brahman-devops.plato.emptool.com    -Alias brahman_devops_plato_dns
New-ACMEIdentifier -Dns plato-dev-bot.plato.emptool.com     -Alias plato_dev_bot_plato_dns
New-ACMEIdentifier -Dns wordpress.plato.emptool.com         -Alias wordpress_plato_dns
New-ACMEIdentifier -Dns csi.plato.emptool.com               -Alias csi_plato_dns


/var/www/empere/certs/haproxy.plato_multi_name_cert.pem plato.emptool.com plato-trading-bot.plato.emptool.com brahman-devops.plato.emptool.com plato-dev-bot.plato.emptool.com wordpress.plato.emptool.com empere.plato.emptool.com csi.plato.emptool.com


https://github.com/ongzhixian/powershell/blob/master/letsencrypt/cko.ps1