# Introduction

Deploy a Jenkins instance to ec2 using ansible. 

Just deploys an instance; not a launch config/scaling group, since once Jenkins is up and running, you will need to configure it, install plugins, setup jobs, etc. What I mean is it cannot be autoscaled; once deployed you need to snapshot it regularly (back it up) so you can recover it in event of corruptions, bad plugins, bad upgrades, etc. Use the Lifecycle Manager which is an excellent way of doing regular snapshots.

# Deploying jenkins

You may wish to adapt the cidr ranges in the security group (sg) yaml files. Also review `vars/app.yaml`.

This was developed with ansible 2.7, so use that or a later version.

Setup your aws credentials in the normal way; I like to use env var AWS_PROFILE.

Example deploy:

```
$ AWS_PROFILE=aws2-admin ansible-playbook -c local -i localhost,  deploy.yaml 

PLAY [Deploy jenkins ec2 instance] *****************************************************************************************************************************************************************************

TASK [fact stack=jenkins] **************************************************************************************************************************************************************************************
ok: [localhost]

TASK [include_tasks] *******************************************************************************************************************************************************************************************
included: /home/amunro/git/spicysomtam/jenkins-aws-ec2/ansible/sg-ssh.yaml for localhost

TASK [create sg jenkins-ssh] ***********************************************************************************************************************************************************************************
changed: [localhost]

TASK [rm sg jenkins-ssh] ***************************************************************************************************************************************************************************************
skipping: [localhost]

TASK [include_tasks] *******************************************************************************************************************************************************************************************
included: /home/amunro/git/spicysomtam/jenkins-aws-ec2/ansible/sg-http.yaml for localhost

TASK [create sg jenkins-http] **********************************************************************************************************************************************************************************
changed: [localhost]

TASK [rm sg jenkins-http] **************************************************************************************************************************************************************************************
skipping: [localhost]

TASK [include_tasks] *******************************************************************************************************************************************************************************************
included: /home/amunro/git/spicysomtam/jenkins-aws-ec2/ansible/jenkins-ec2.yaml for localhost

TASK [create jenkins instance] *********************************************************************************************************************************************************************************
changed: [localhost]

TASK [rm jenkins instance running] *****************************************************************************************************************************************************************************
skipping: [localhost]

TASK [rm jenkins instance stopped] *****************************************************************************************************************************************************************************
skipping: [localhost]

PLAY RECAP *****************************************************************************************************************************************************************************************************
localhost                  : ok=7    changed=3    unreachable=0    failed=0   
```

After deployment, head to `http://<public-dns>:8080`, and begin the Jenkins configure process.

# Destroying the Jenkins instance

To be run with care; you might wish to try this out just after deploy, so you understand how it works (and then deploy again).

Destroying the Jenkins instance:

```
ansible-playbook -c local -i localhost,  destroy.yaml 

PLAY [Destroy jenkins ec2 instance] ****************************************************************************************************************************************************************************

TASK [fact stack=jenkins] **************************************************************************************************************************************************************************************
ok: [localhost]

TASK [include_tasks] *******************************************************************************************************************************************************************************************
included: /home/amunro/git/spicysomtam/jenkins-aws-ec2/ansible/jenkins-ec2.yaml for localhost

TASK [create jenkins instance] *********************************************************************************************************************************************************************************
skipping: [localhost]

TASK [rm jenkins instance running] *****************************************************************************************************************************************************************************
changed: [localhost]

TASK [rm jenkins instance stopped] *****************************************************************************************************************************************************************************
ok: [localhost]

TASK [include_tasks] *******************************************************************************************************************************************************************************************
included: /home/amunro/git/spicysomtam/jenkins-aws-ec2/ansible/sg-http.yaml for localhost

TASK [create sg jenkins-http] **********************************************************************************************************************************************************************************
skipping: [localhost]

TASK [rm sg jenkins-http] **************************************************************************************************************************************************************************************
changed: [localhost]

TASK [include_tasks] *******************************************************************************************************************************************************************************************
included: /home/amunro/git/spicysomtam/jenkins-aws-ec2/ansible/sg-ssh.yaml for localhost

TASK [create sg jenkins-ssh] ***********************************************************************************************************************************************************************************
skipping: [localhost]

TASK [rm sg jenkins-ssh] ***************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP *****************************************************************************************************************************************************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0   
```

# Things to consider after deploy

* Make the root volume larger; 8Gb is a bit small for Jenkins so a better size might be 20Gb.
* Switch to a more powerful instance type; `t2.small` with 2Gb of memory just allows Jenkins to run. Consider at least a `t3.medium` (`t3's` are cheaper than `t2's` and have more cores; `medium` gives 4Gb of memory).
* Backup your instance regularly to protect against bad plugin/jenkins upgrades; as mentioned the Lifecycle Manager is a good way to do it.
* Integrate your Jenkins with ldap or Active Directory to simplify user management.


