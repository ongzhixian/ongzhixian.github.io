# Google App Script (GAS)

Home
https://script.google.com/home


# CLI commands

## Installation -- Updating npm,, then install

npm install -g npm
npm install @google/clasp -g

## Login/Logout

clasp login
clasp logout


Remarks:

Login open browser for you login -- 
Authorization successful.
Default credentials saved to: ~\.clasprc.json (C:\Users\zong\.clasprc.json)

## Create new script

clasp create [scriptTitle]

This command also creates two files in the current directory:

A .clasp.json file storing the script ID.
An appsscript.json project manifest file containing project metadata.

## Clone existing

clasp clone <scriptId>

ou can find the script ID of a project by opening the project in the Apps Script editor and selecting File > Project properties > Info.

## Download/Upload a script project/Open project in Google Apps Script editor

clasp pull
clasp push
clasp open

## List project versions / deployments

clasp versions
clasp deployments




# Reference

*   Command Line Interface using clasp

    clasp is an open-source tool, separate from the Apps Script platform, 
    that lets you develop and manage Apps Script projects from your terminal rather than the Apps Script editor.

    https://developers.google.com/apps-script/guides/clasp

