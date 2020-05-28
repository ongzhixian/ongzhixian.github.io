$headers = @{ Authorization="Bearer ya29.a0AfH6SMCUtakvMCKwuLXt2WurR-vPGXWXJ-WvXYHKSD_5ERBdq-jXNsZ5rlRe7Yu7-I0qwHshkpFlMdC9q5M82eb6BBlduQgKCNjguTgPyOKzx_sN55mwiYHxVS9_9cqUywDRmfyAqTyakUMAaiHgNCvmGapt4zlvt-M" }

# Tasks

## * Returns all the authenticated user's task lists

GET
https://www.googleapis.com/tasks/v1/lists/tasklist/tasks

$a = Invoke-RestMethod -Headers $headers -Uri https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks

$a.items

kind     : tasks#task
id       : bFRlQ3kyaWlaY1JheGd5WA
etag     : "MTUwOTAwNzAxNA"
title    :
updated  : 5/28/2020 6:21:46 AM
selfLink : https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks/bFRlQ3kyaWlaY1JheGd5WA
position : 00000000000000000001
status   : needsAction

kind     : tasks#task
id       : SnZQXzhGWmxFeHgxdVBMeg
etag     : "MTUwOTAwNjQwNg"
title    : Sample task
updated  : 5/28/2020 6:21:46 AM
selfLink : https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks/SnZQXzhGWmxFeHgxdVBMeg
position : 00000000000000000000
status   : needsAction


## Returns the specified task

GET 
https://www.googleapis.com/tasks/v1/lists/tasklist/tasks/task



$a = Invoke-RestMethod -Headers $headers -Uri https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks/bFRlQ3kyaWlaY1JheGd5WA

$a

kind     : tasks#task
id       : bFRlQ3kyaWlaY1JheGd5WA
etag     : "MTUwOTAwNzAxNA"
title    :
updated  : 5/28/2020 6:21:46 AM
selfLink : https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks/bFRlQ3kyaWlaY1JheGd5WA
position : 00000000000000000001
status   : needsAction


## Creates a new task on the specified task list. 

Note: Fails with HTTP code 403 or 429 after reaching the storage limit of 100,000 tasks per account.

POST https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks

$a = Invoke-RestMethod -Headers $headers -Uri https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks -Method 'POST' -Body "{ `"title`" : `"sample json`" }" -ContentType "application/json"


$a = Invoke-RestMethod -Headers $headers -Uri https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks -Method 'POST' -Body "title=`"sample json 22`""

 -ContentType "application/json"



ZX: Invoke-WebRequest give more verbose results in $a
$a = Invoke-WebRequest -Headers $headers -Uri https://www.googleapis.com/tasks/v1/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow/tasks -Method 'POST' -Body "{ `"title`" : `"sample json`" }" -ContentType "application/json"















# TaskLists

## * Returns all the authenticated user's task lists

GET https://www.googleapis.com/tasks/v1/users/@me/lists

$a = Invoke-RestMethod -Headers $headers -Uri https://www.googleapis.com/tasks/v1/users/@me/lists

$a.items

kind     : tasks#taskList
id       : MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow
etag     : "MTUwOTAwNzA0NQ"
title    : My Tasks
updated  : 5/28/2020 6:21:46 AM
selfLink : https://www.googleapis.com/tasks/v1/users/@me/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow

kind     : tasks#taskList
id       : MDIxNTg3NzQ3NDEwNTY5NzIxOTk6NjQ2MjkyMTM3NzYzOTMwMzow
etag     : "MTM0ODI0MzI3Ng"
title    : Demo task list
updated  : 6/13/2019 10:22:51 AM
selfLink : https://www.googleapis.com/tasks/v1/users/@me/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6NjQ2MjkyMTM3NzYzOTMwMzow

kind     : tasks#taskList
id       : enlqcUdlQzU5RFdkS01hXw
etag     : "MTg1NTcwNjg5Mg"
title    : Empere task list
updated  : 8/8/2019 12:23:22 AM
selfLink : https://www.googleapis.com/tasks/v1/users/@me/lists/enlqcUdlQzU5RFdkS01hXw



## Returns the authenticated user's specified task list.

GET https://www.googleapis.com/tasks/v1/users/@me/lists/tasklist

```
$a = Invoke-RestMethod -Headers $headers -Uri https://www.googleapis.com/tasks/v1/users/@me/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow
```

$a

kind     : tasks#taskList
id       : MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow
etag     : "MTUwOTAwNzA0NQ"
title    : My Tasks
updated  : 5/28/2020 6:21:46 AM
selfLink : https://www.googleapis.com/tasks/v1/users/@me/lists/MDIxNTg3NzQ3NDEwNTY5NzIxOTk6MDow


