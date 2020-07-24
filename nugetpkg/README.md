# Create nuget packages as plugins for Resharper


# Notes

1.  The id parameter in metadata MUST consist of two parts (company and a plugin name) separated by . (dot): 
    MyCompany.MyPlugin in our example.

2.  <dependency id="Wave" version="[8.0]" /> specifies the version of ReSharper your plugin targets. 
    Thus, Wave 8.0 stands for ReSharper 2017.1, Wave 9.0 for ReSharper 2017.2, and so on. 
    Note that we put the strict limitation on the required ReSharper version (by using the square brackets in [8.0]) 
    – ReSharper SDK is not backward compatible!


# Instruction to build package
nuget pack myplugin.nuspec


# Reference
https://www.jetbrains.com/help/resharper/sdk/HowTo/Start/CreateNuGetPackageForPlugin.html
