Hosting a Local Git Server on Windows
=====================================

Here's my setup:

-   I have a very beefy Windows computer that has a bunch of storage attached. I effectively treat this as a combination game PC/central server. I want other nodes on the network to be able to talk to it.
-   I also have a M1 MacBook Air. I do photo editing on it, use it while I'm watching TV on the couch, etc.

I want the MacBook to be able to push/pull from my Windows PC. How hard can it be?

First, install OpenSSH. This comes with Windows now, follow these instructions: https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui

Second, set the default shell to Powershell by following these instructions: https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration

.. note:: This took me a while to figure out. This turned out to be a hard problem to Google. I had to bust out ProcMon and noticed that the default shell was running ``git-upload-pack 'git_test'`` very literally; it was looking for a file literally called ``'git_test'``. The behavior was due to how ``cmd.exe`` (the default default shell) was processing the command. When I changed this from ``cmd.exe`` to Powershell it started working.

Third, install Git for Windows: https://git-scm.com/download/win

Now, on my MacBook I should be able to clone over SSH::

    git clone windows-user@windows-pc:git_test

.. warning:: I still have this weird quirk where it keeps asking me for my Windows user password on operations like ``git push``. I don't know if that's a Windows config issue or a problem with my MacBook. It looks like I only need to enter my password once then spam the enter key.

.. note:: Relative paths are relative to ``C:\Users\windows-user``
