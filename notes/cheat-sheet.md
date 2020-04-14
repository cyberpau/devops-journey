## Forking Repository
#### Source: https://blog.scottlowe.org/2015/01/27/using-fork-branch-git-workflow/
1. Making a Local Clone

    `git clone https://github.com/openvswitch/openvswitch.github.io.git`

2. Adding a Remote

    `git remote add upstream https://github.com/openvswitch/openvswitch.github.io.git`

3. Working in a Branch

    + Create a new branch and checkout

        `git checkout -b <new branch name>`



## Generating new SSH key pair
#### Source: https://docs.gitlab.com/ee/ssh/

**ED25519 SSH keys (Recommended)**

    `ssh-keygen -t ed25519 -C "<comment>"`


**RSA SSH keys**

    `ssh-keygen -t rsa -b 2048 -C "email@example.com"`

## Adding an SSH key to your GitLab account
Now you can copy the SSH key you created to your GitLab account. To do so, follow these steps:

1. Copy your public SSH key to a location that saves information in text format.

        `~/.ssh/id_ed25519.pub`

2. Navigate to http://gitlab.com and sign in.
3. Select your avatar in the upper right corner, and click Settings
4. Click SSH Keys.
5. Paste the public key that you copied into the Key text box.
6. Make sure your key includes a descriptive name in the Title text box, such as Work Laptop or Home Workstation.
7. Include an (optional) expiry date for the key under “Expires at” section. (Introduced in GitLab 12.9.)
8. Click the Add key button.