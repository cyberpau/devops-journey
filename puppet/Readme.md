1. Install vagrant and virtual box
2. Copy vagrantfile and do a `vagrant up`
3. SSH to our master using `vagrant ssh`
4. Use superuser bash `sudo su -`
5. Add puppet repository `rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm`
6. `yum -y install puppetserver vim git`
7. `vim /etc/sysconfig/puppetserver`
8. Edit JAVA_ARGS = `"-Xms512m -Xmx512m"`
9. `systemctl start puppetserver`
10. `systemctl status puppetserver`
12. `systemctl enable puppetserver`
13. `vim /etc/puppetlabs/puppet/puppetconf`
14. Add new section:<pre><code>[agent]
server = master.puppet.vm</code>
</pre>

15. Use ruby gem installed with puppetserver by editing bash_profile <pre><code>
PATH=$PATH:/opt/puppetlabs/puppet/bin
</code></pre> 
then `exec bash` and `source .bash_profile`

16. <pre><code>
mkdir /etc/puppetlabs/r10k
vi /etc/puppetlabs/r10k/r10k.yaml
</code></pre> and finally deploy the puppet code by `r10k deploy environment -p`