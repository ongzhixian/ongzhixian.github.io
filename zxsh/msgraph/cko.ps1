# Demo how to use access token
# GET /v1.0/me/messages
# Host: https://graph.microsoft.com
# Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik5HVEZ2ZEstZnl0aEV1Q...

$base_url = "https://graph.microsoft.com"
$sub = "/v1.0/me"


# What an access token from using a tenant (Azure AD) looks like
# $access_token = "eyJ0eXAiOiJKV1QiLCJub25jZSI6InNnRXpqY2NTakIzSk9jenI0dlliQjNHT21ERUNnTVJWWlUwVzRLV1p5cVkiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0VHVoTUptRDVNN0RMZHpEMnYyeDNRS1NSWSIsImtpZCI6IkN0VHVoTUptRDVNN0RMZHpEMnYyeDNRS1NSWSJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC8xNzM3MDU3NC03MTEwLTQwYzMtYTMxNy0xMmFjM2ViZjllOTYvIiwiaWF0IjoxNTkwOTk1NTEyLCJuYmYiOjE1OTA5OTU1MTIsImV4cCI6MTU5MDk5OTQxMiwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFVUUF1LzhQQUFBQUpsVWlMSWoxYWFEcU5pTDdPbU5wN3h0MFBiU0RTakNCOEpFN3NMY3RwZmYwWFY2UktPbUttYjVNZWsxUUFWUC9DV25qSklDbWpkZDBaaU9qeXJZenJ3PT0iLCJhbHRzZWNpZCI6IjE6bGl2ZS5jb206MDAwMTE4RTgyOUM5NUUwQiIsImFtciI6WyJwd2QiXSwiYXBwX2Rpc3BsYXluYW1lIjoienhzaCIsImFwcGlkIjoiZDg3N2VmMjctYTExMC00ZTBmLTgyZGQtZTZjOGU1Mzg1YzYyIiwiYXBwaWRhY3IiOiIwIiwiZW1haWwiOiJ6aGl4aWFuQGhvdG1haWwuY29tIiwiZmFtaWx5X25hbWUiOiJPbmciLCJnaXZlbl9uYW1lIjoiWmhpeGlhbiIsImlkcCI6ImxpdmUuY29tIiwiaXBhZGRyIjoiNDIuNjAuMjMuMCIsIm5hbWUiOiJaaGl4aWFuIE9uZyIsIm9pZCI6ImI0ODRmMjA0LTcyYmMtNDc4OC1hOGJhLWEyNzE4MDgyMTdhZCIsInBsYXRmIjoiMyIsInB1aWQiOiIxMDAzQkZGRDk4NjA1MENEIiwic2NwIjoiR3JvdXAuUmVhZC5BbGwgR3JvdXAuUmVhZFdyaXRlLkFsbCBNYWlsLlJlYWQgb3BlbmlkIFRhc2tzLlJlYWQgVGFza3MuUmVhZFdyaXRlIFRhc2tzLlJlYWRXcml0ZS5TaGFyZWQgVXNlci5SZWFkIFVzZXIuUmVhZFdyaXRlIHByb2ZpbGUgZW1haWwiLCJzdWIiOiJIWkdnTzZ1c3BMZGNQalltSDFRUDA2ZVBlaUZ5QXhBZzYwaG8zUGN0d1RBIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IkFTIiwidGlkIjoiMTczNzA1NzQtNzExMC00MGMzLWEzMTctMTJhYzNlYmY5ZTk2IiwidW5pcXVlX25hbWUiOiJsaXZlLmNvbSN6aGl4aWFuQGhvdG1haWwuY29tIiwidXRpIjoiZUhZZWEwY3p1MDIzS29TbmpGWTFBQSIsInZlciI6IjEuMCIsIndpZHMiOlsiNjJlOTAzOTQtNjlmNS00MjM3LTkxOTAtMDEyMTc3MTQ1ZTEwIl0sInhtc19zdCI6eyJzdWIiOiJhbEI0YVBJLVE4SDZURmlRbnA2aUlFeGVTYWZSSXFmUWdDa1FpeDA2a1NRIn0sInhtc190Y2R0IjoxNDY1OTc0MDk2fQ.AYPXOv9DLAWXg1H5fEBqyWrC0_bAKo2Vbsii3T5ALqNEpBg8OuwgriV6qCLqx4KaJBEXpIPAiNnN6EdckoXM1QvrIH_etJJl6GGffeYc6tlZfDNjE6eDObO6rtnbsQVmuU-H4pLCFlD-EvRpSRgORZStZfweFbzqnqhYP4MarSsnW50DIhzcHaWZaJLfAxqYcNXPNa9pqnTD9EQJLYuG2TFA1Fr48Vf5VcWG2vY5IOtTpNnZCgUM7ie85MNpxrrTcgtQV9sieDfjSISuQAUSxl4wTVjctq6BhQsre_1KDNxQJijCzH0-f_K5euJTjoIJK58rZAVex5ydasYiqI40-g

# What an access token from using Microsoft "common" tenant looks like
$access_token = "EwCAA8l6BAAUO9chh8cJscQLmU+LSWpbnr0vmwwAAbaMkfeDiEvWnoNNd+I/6zvw2ULXGJw11BNemqD9wsDPn+4YFhnofkWbk4xqib+ECtPV1V7HzagNwiRt1Q+8CCJ5ljQOs+VGNxdHA+56xWa5ab0OqpsfDHDCIpVsbXQ+2Mvd2wAh4XKlKBQmokP3lLAbcK0yLj95H+Wig2PJdhpuYsqVV1kppkIzmu/zjgjURUK8derwhTzOG2U3gKuH0TP19mxdvDdmlHScUKiVS2z4ak1NF9XXm0/gYGfejLI/frVu2mLARK4AWmsrtynXAL0yLUBhDfyCZKxj7RmZGevdYCq0Y/lPuzqSUFMu6bub+mnz5l0Kz49OcCj6yxznopkDZgAACHZPC+cXXS4kUALwAW3vXBr+cFhnMDYFwnNjw+38N1IqLWOUU8Fgdm/3BI19OsbOHXM/plCPaOTqs9+rHfy6QYl/kHeDMNseOxpbjgNbeyU7gTHw7/VNJvZ9XbYWH4qgOQbE73vUU5kqTVGNdwpf8IoNoOlPmaLa3bRCAocvAZ93MzMQn7w+nTt9SQi/kyCvv6T+WSjpia+LgyalnishwNk9IbyyUI/2xZ2lULKmsrrSLIuOTqqJibro3Aj8B1nFX8I83zRsZHTUiN22No3J+JUNnkKuF6fAzA5ptNefuzWaOwO7K6nC2GJE9H75DizFzZdznd1y7fJF1DRufzX52AZdk3sL8QBY+11mOz3tO3x22np37NliEmCm8vZTpCEsWT+Zo6XmjlBqXoG7F/S4Sxj7036htTuN+rtKoCQeVbcCPKB6ej99vbdrESGz6FXefYIKHjxcstgdt1r5ehYEz9c0oUBWy1FTGHZubZrSh4nOJ77ssP6j8VMt1vRgvkPlOAZH2RpRD5kkR8zX7nuv4FeHyJui+kRi/unSdKD3O5YOIpq5B1En0ra6upe7K7vygzTOgyPfazBcqPSvqTI1OxTce70Bti+iCUwbmLKJPrNHaC+9n9fv+XCQRNnUsf/nbl3De0YiPBKIjDKxvC6UOTn3W04yPMF4eUYp2PmMZm/69oKnkFZdXLIzZUmO2uzTTqSuD9HyCIlDrlQpzijGcF2QQ4EOrZ2RNEspnGa3xvLzS6BzqxwroboBBLwIqP3uji2Owc3hfMNmlgkjcI4ERaqjMx8c1BMSOdTXhAI="

$endpoint_url = "$base_url$sub"

#overwrite
$endpoint_url = "https://graph.microsoft.com/beta/me/outlook/tasks"

# $a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks?orderby=createdDateTime"
# $a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks?select=subject,createdDateTime&"
# $a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks?select=subject,createdDateTime&orderby=createdDateTime"
# $a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks?select=subject,createdDateTime&orderby=createdDateTime%20desc"


$headers = @{ 
    Authorization="Bearer $access_token" 
}

$headers

$endpoint_url
$a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks"
$a



$a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks?select=subject,createdDateTime&orderby=createdDateTime%20desc&count=true"
$a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks?select=subject%2ccreatedDateTime&orderby=createdDateTime+desc&count=true&$skip=10"

$a = Invoke-RestMethod -Headers $headers -Uri $a."@odata.nextLink"

$a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks?select=subject%2ccreatedDateTime&orderby=createdDateTime+desc&count=true&$top=270"


$a = Invoke-RestMethod -Headers $headers -Uri $a."@odata.nextLink"; $a.value | Format-Table $fmt; $a."@odata.nextLink"

# Create tasks

$body = @{
    subject = "Shop for children's weekend";
}

$headers["Content-Type"] = "application/json"

POST https://graph.microsoft.com/beta/me/outlook/tasks

$a = Invoke-RestMethod -Headers $headers -Uri "https://graph.microsoft.com/beta/me/outlook/tasks" -Method Post -Body (ConvertTo-Json $body)

