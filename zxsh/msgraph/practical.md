# Practical 

This practical is a "auth code grant" practical.


## Register App at Azure (one-time)

Register app at https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade

Application (client) ID
d877ef27-a110-4e0f-82dd-e6c8e5385c62

Directory (tenant) ID
17370574-7110-40c3-a317-12ac3ebf9e96


## Get authorization code

HTTP GET:

https://login.microsoftonline.com/17370574-7110-40c3-a317-12ac3ebf9e96/oauth2/v2.0/authorize?
response_type=code
&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient
&client_id=d877ef27-a110-4e0f-82dd-e6c8e5385c62
&scope=openid%20offline_access%20https%3A%2F%2Fgraph.microsoft.com%2Fmail.read
&response_mode=query
&state=12345

Request:
https://login.microsoftonline.com/17370574-7110-40c3-a317-12ac3ebf9e96/oauth2/v2.0/authorize?response_type=code&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient&client_id=d877ef27-a110-4e0f-82dd-e6c8e5385c62&scope=openid%20offline_access%20https%3A%2F%2Fgraph.microsoft.com%2Fmail.read&response_mode=query&state=12345

Response:
https://login.microsoftonline.com/common/oauth2/nativeclient?code=OAQABAAIAAAAm-06blBE1TpVMil8KPQ41nmLSFyRcjnuk8iDdnJgDvXgalD9qAYR7RtaBeG2IozRKtpTR-HFby4_dH3GiXdgWSwyyE4LBlKBcRxjgMP0s6qXG-QJ_g-kqC1NsR36WnDP66QkjmDgV-UeN6utUzrxv_zN_mGVYEnBPgssZuLsegaTHuXaw6x40MR4cErFf7LF_iK2uk_kr3rI_TH_0NGH03Rg0SMkmOh5Skm9U4ytGw6MU9g3QAzEueGVswHfh42YGNklEngoz_ReDhU6QZ9ARtBFZKV8TMRnVFRejk1E_yghn_0LVmAhJnxQnWjEeWqrO3PuCTAZAYayJPkwpVsTrm_ZMrAd5-37XCC_8N5zaPzt5BSeVWfzVyuEmiXf6355eKJraObfK1VfuCnebGZCjNARGx6UjLnuOi9J2WicgfEtwKu6x4IrImtT6avo7qZzHaboGLAN-2PTE8oP9VqvIjIlo0UYWboKchW7X_ce84yLpQBl97vA1i2aSmEAca5ctjISONZK-sEhapP56j7YO-wVYWZqJIImmzpwE3L4mJEQQlYT6tBbvUsFsUIj3S9ZDbZ1mwtx5dm6r_aQ94e5DSZxdXH-ako2CE9inbes0ySMAsLs62gSgXLCiLjoOzbbt0T_p3UL1edpQ5SAGd1CFfRHtEOfGZ7OseBxkrsmmOq9oXc7z-J5xygMx0QBYObHaxtqj_0yvD-CarlaqNP3wRzGsYbXDuADSA3rqITyf04_hPrkFYVwGGbw1g25WHlepaIfoIPZz0hEC6uxJxqBF0DJkbU9guCuiWrgnZzm1HrPVr967y9eT3SPkBfIdI0xu4W8z6KfoJDmaNwpF3Fk8WJtsMyW-AbVSMrChWutzqiuwjFUjEVd9FnCO6NamEFfNZA0knNfYS191-wINk2rBygyYVv5mLcNo0-9RRtjVa9AWg37Kdj0cPNesBHEnH7RnjhZsMyeSEuzWEWSepEFuLxny5SRo_1IXXb0eexaq63n-V_XeIcOf7No_JjtN0_ixQblUwdxr3NTPyt9iInWeLiDozHFeFFTMUYMj_Z4apTmGhs342KrnNIGf3OiADzSVbDukMvdKnXdDTKpl-XXQlHXggEvXDlm68w6uynU9tZXAyxx0M-TcB0knt9ZPdLpEvxs8o-Di1eM_wOBjY4FUTeyjBaLxpVbdwEUDOmhJRsgj0OZXLvo_4hL2OUc8wS6rrn0VcxRrwSzEv-QnEWN8NuOW8Acsr3FGOjK1dGHqvitNGciAGzPX4eK3bi8Axo8gAA&state=12345&session_state=55a7d6b5-7153-460a-88d5-7dfaca47dd89

The important takeaway from response:
code=
OAQABAAIAAAAm-06blBE1TpVMil8KPQ41nmLSFyRcjnuk8iDdnJgDvXgalD9qAYR7RtaBeG2IozRKtpTR-HFby4_dH3GiXdgWSwyyE4LBlKBcRxjgMP0s6qXG-QJ_g-kqC1NsR36WnDP66QkjmDgV-UeN6utUzrxv_zN_mGVYEnBPgssZuLsegaTHuXaw6x40MR4cErFf7LF_iK2uk_kr3rI_TH_0NGH03Rg0SMkmOh5Skm9U4ytGw6MU9g3QAzEueGVswHfh42YGNklEngoz_ReDhU6QZ9ARtBFZKV8TMRnVFRejk1E_yghn_0LVmAhJnxQnWjEeWqrO3PuCTAZAYayJPkwpVsTrm_ZMrAd5-37XCC_8N5zaPzt5BSeVWfzVyuEmiXf6355eKJraObfK1VfuCnebGZCjNARGx6UjLnuOi9J2WicgfEtwKu6x4IrImtT6avo7qZzHaboGLAN-2PTE8oP9VqvIjIlo0UYWboKchW7X_ce84yLpQBl97vA1i2aSmEAca5ctjISONZK-sEhapP56j7YO-wVYWZqJIImmzpwE3L4mJEQQlYT6tBbvUsFsUIj3S9ZDbZ1mwtx5dm6r_aQ94e5DSZxdXH-ako2CE9inbes0ySMAsLs62gSgXLCiLjoOzbbt0T_p3UL1edpQ5SAGd1CFfRHtEOfGZ7OseBxkrsmmOq9oXc7z-J5xygMx0QBYObHaxtqj_0yvD-CarlaqNP3wRzGsYbXDuADSA3rqITyf04_hPrkFYVwGGbw1g25WHlepaIfoIPZz0hEC6uxJxqBF0DJkbU9guCuiWrgnZzm1HrPVr967y9eT3SPkBfIdI0xu4W8z6KfoJDmaNwpF3Fk8WJtsMyW-AbVSMrChWutzqiuwjFUjEVd9FnCO6NamEFfNZA0knNfYS191-wINk2rBygyYVv5mLcNo0-9RRtjVa9AWg37Kdj0cPNesBHEnH7RnjhZsMyeSEuzWEWSepEFuLxny5SRo_1IXXb0eexaq63n-V_XeIcOf7No_JjtN0_ixQblUwdxr3NTPyt9iInWeLiDozHFeFFTMUYMj_Z4apTmGhs342KrnNIGf3OiADzSVbDukMvdKnXdDTKpl-XXQlHXggEvXDlm68w6uynU9tZXAyxx0M-TcB0knt9ZPdLpEvxs8o-Di1eM_wOBjY4FUTeyjBaLxpVbdwEUDOmhJRsgj0OZXLvo_4hL2OUc8wS6rrn0VcxRrwSzEv-QnEWN8NuOW8Acsr3FGOjK1dGHqvitNGciAGzPX4eK3bi8Axo8gAA

