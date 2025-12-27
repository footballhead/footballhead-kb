PowerShell
==========

PowerShell looks like a great scripting language but is incredibly verbose for a shell. (The solution is to use `autocomplete <https://powershell.org/2022/03/stop-typing-so-much/>`_ which works I guess.)

* Removing a file:
    * cmd: ``del``
    * sh: ``rm``
    * PowerShell: ``Remove-Item -Path <path>``
* Printing environment variables:
    * cmd: ``set``
    * sh: ``printenv``
    * PowerShell ``Get-Item env:``
* Deleting a directory:
    * cmd: ``rmdir /S /Q <dir>``
    * sh: ``rm -rf <dir>``
    * PowerShell: ``Remove-Item -Path <path> -Recurse``
