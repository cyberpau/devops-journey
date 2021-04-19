# **My DevOps Journey** by John Paulo Mataac

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

This compilation is mainly inspired by ["Kubernetes for Full Stack Developers"](https://assets.digitalocean.com/books/kubernetes-for-full-stack-developers.pdf) book by DigitalOcean, ["Just me and Open Source"](https://www.youtube.com/channel/UC6VkhPuCCwR_kG0GExjoozg) Youtube Videos, and ["Cloud Native Computing Foundation (CNCF)"](https://www.youtube.com/c/cloudnativefdn/videos) Webinars.

Our ideal goal is to learn and complete these [Roadmap](https://github.com/kamranahmedse/developer-roadmap)

For the full list of sources, you can take a look here.

## **Topics Covered**:
1. [Create Multi Node Kubernetes Cluster using Ansible on Centos 7](#Create-Multi-Node-Kubernetes-Cluster-using-Ansible-on-Centos-7)
2. [Building Helm Charts From the Ground Up](#Building-Helm-Charts-From-the-Ground-Up)
3. [Key Notes for Modern Applications](#Key-Notes-for-Modern-Applications)
4. [Running Jenkins slave agents in Kubernetes](#Running-Jenkins-slave-agents-in-Kubernetes)
5. [How to use Statefulsets](#How-to-use-Statefulsets)
6. [Build a Node.js Application with Docker](#Build-a-Node.js-Application-with-Docker)
7. [Puppet, Vagrant, Virtualbox](#Puppet,-Vagrant,-Virtualbox)
[👇](#Blank)

## **Sample Machines**:

| Role      | hostname      | vCPU | RAM | ipv4 address          | notes                                         |
|-----------|---------------|------|-----|-----------------------|-----------------------------------------------|
| master    | kmaster       |  3   | 4Gb | 192.168.1.15 /24      | Ansible, Helm, Kubernetes Dashboard           |
| worker    | kworker1      |  1   | 2Gb | 192.168.1.16 /24      |                                               |
| worker    | kworker2      |  1   | 2Gb | 192.168.1.17 /24      |                                               |

------------


## **Create Multi Node Kubernetes Cluster using Ansible on Centos 7**

1. Run `./playbook/kube-dependencies` using ansible playbook.

        ansible-playbook -i hosts kube-dependencies.yml -K

2. After this, run the following on each machines:

    **Important Note:** The instructions from the book has some issues on k8s v1.9. I'm currently working on to fix this, but for the meantime, please run the following on the all nodes:
    
        ### Disable swap
        swapoff -a
        sed -i 's/^\(.*swap.*\)$/#\1/' /etc/fstab

        ### Restart Services
        systemctl daemon-reload
        systemctl enable docker
        systemctl restart docker

        ### Disable firewall
        systemctl stop firewalld
        systemctl disable firewalld

2. Run `./playbook/master-init` using ansible playbook.

    **Important Note:** The instructions from the book has some issues on k8s v1.9. I'm currently working on to fix this, but for the meantime, please run the following on the master node:


        ### load netfilter probe specifically
        modprobe br_netfilter

        ### disable SELinux. If you want this enabled, comment out the next 2 lines. But you may encounter issues with enabling SELinux
        setenforce 0
        sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

        ### Enable IP Forwarding
        echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
        cat <<EOF >  /etc/sysctl.d/k8s.conf
        net.bridge.bridge-nf-call-ip6tables = 1
        net.bridge.bridge-nf-call-iptables = 1
        EOF

        ### Restarting services
        systemctl daemon-reload
        systemctl restart kubelet

3. Once everything is ready, you can go ahead and [play with Kubernetes](https://kubernetes.io/docs/tutorials/kubernetes-basics/):

    
-----


## **Building Helm Charts From the Ground Up**

1. Install `helm 3` on Centos7

        cd /tmp
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
        chmod u+x get_helm.sh

    To check the version installed

        helm version
    
2. To create a new helm chart from scratch:

        helm create samplechart

    But for this demo, let us install the Kubernetes Dashboard

        helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
        helm install my-kube-dashboard kubernetes-dashboard/kubernetes-dashboard
    
    To download a local copy from the repository

        helm pull kubernetes-dashboard/kubernetes-dashboard

3. To access our dashboard using NodePort, let us edit our service and replace ClusterIP with NodePort. Make sure we also set the port of nodePort (e.g. 32323)

        kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard
        ### Edit the type = NodePort and nodePort = 32323 as shown below:

        # Please edit the object below. Lines beginning with a '#' will be ignored,
        # and an empty file will abort the edit. If an error occurs while saving this file will be
        # reopened with the relevant failures.
        #
        apiVersion: v1
        kind: Service
        metadata:
        annotations:
            kubectl.kubernetes.io/last-applied-configuration: |
            {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"k8s-app":"kubernetes-dashboard"},"name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"},"spec":{"ports":[{"port":443,"targetPort":8443}],"selector":{"k8s-app":"kubernetes-dashboard"}}}
        creationTimestamp: "2020-10-14T09:17:19Z"
        labels:
            k8s-app: kubernetes-dashboard
        name: kubernetes-dashboard
        namespace: kubernetes-dashboard
        resourceVersion: "129782"
        selfLink: /api/v1/namespaces/kubernetes-dashboard/services/kubernetes-dashboard
        uid: 75380b02-4b80-4083-9f29-3815a4308362
        spec:
        clusterIP: 10.101.107.148
        externalTrafficPolicy: Cluster
        ports:
        - nodePort: 32323       ### <--- Here --->
            port: 443
            protocol: TCP
            targetPort: 8443
        selector:
            k8s-app: kubernetes-dashboard
        sessionAffinity: None
        type: NodePort          ### <--- Here --->
        status:
        loadBalancer: {}

    Then, create a service account and clusterrolebinding with admin priveledge (WARNING: It is not advisable to use admin-level account for kubernetes dashboard)

        kubectl create -f ./sa/sa_cluster_admin.yaml
    
        kubectl -n kube-system describe sa dashboard-admin
        ## copy the token
        kubectl -n kubesystem describe secret dashboard-admin-token-xxxxx
    
    Use the toket generated to access the dashboard on `https://<master-ip-address>:<32323>/`

    To learn more about Kubernetes Dashboard, you can visit [The Ultimate Guide to the Kubernetes Dashboard: How to Install, Access, Authenticate and Add Heapster Metrics](https://www.replex.io/blog/how-to-install-access-and-add-heapster-metrics-to-the-kubernetes-dashboard)

-----

## **Key Notes for Modern Applications**

### Modern Stateless Applications are usually developed using the following principles:
1. [Cloud Native](https://github.com/cncf/toc/blob/master/DEFINITION.md)
2. [Twelve Factor](https://12factor.net/)


### Common Types of Health Check
1. Readiness probe - lets Kubernetes know when your application is ready to receive traffic
2. Liveness probe - lets Kubernetes know when your application is healthy and running.


### Logging and Monitoring (RED)
1. Rate: The number of requests received by your application
2. Errors: The number of errors emitted by your application
3. Duration: The amount of time it takes your application to serve a response


### Implementing Build Pipelines
- Watch source code repositories for changes
- Run smoke and unit tests on modified code
- Build container images containing modified code
- Run further integration tests using built container images
- If tests pass, tag and publish images to registry
- (Optional, in continuous deployment setups) Update Kubernetes Deployments and roll out images to staging/production clusters

### Logging and Monitoring
1. Premetheus
2. Grafana


-----

## Running Jenkins slave agents in Kubernetes

1. First, create a Jenkins docker container and its respective volume. Check Just Me and Open Source's awesome video on: https://www.youtube.com/watch?v=OfoAYVi1YcU for the complete step by step.

    This is inspired by Just Me and Open Source's video on [Running Jenkins slave agents in Kubernetes](https://www.youtube.com/watch?v=OfoAYVi1YcU) and Riot Game's guide on [Putting Jenkins in a Docker Container](https://technology.riotgames.com/news/putting-jenkins-docker-container)

        sudo mkdir /var/jenkins_home
        docker run --name jenkins -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

2. Then, let's set up continuous integration pipelines in Jenkins. This is inspired by Digital Ocean's guide on [How to Set Up Continuous Integration Pipelines in Jenkins on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-continuous-integration-pipelines-in-jenkins-on-ubuntu-16-04). The only difference is that we are using Centos 7 instead of Ubuntu.


-----

## **How to use Statefulsets**
1. First install and setup nfs-utils

        sudo yum intall nfs-utils -y
        sudo systemctl enable nfs-server
        sudo mkdir -p /srv/nfs/kubedata
        sudo mkdir /srv/nfs/kubedata/{pv0,pv1,pv2,pv3,pv4}
        
2. Edit /etc/exports and add the following

        /srv/nfs/kubedata       *(rw,sync,no_subtree_check,insecure)

3. Edit folder permissions and mount the volume

        sudo chmod -R 777 /srv/nfs
        mount -t nfs 192.168.1.15:/srv/nfs/kubedata /mnt
        ls /mnt


## **Build a Node.js Application with Docker**
1. First, install npm

        sudo yum install npm -y


## **Puppet, Vagrant, Virtualbox**
This tutorial is based on LinkedIn course "Learning Puppet". On this steps, you will learn to provision your infrastucture using code (IaaC) by using Puppet.

1. Install Vagrant and Virtualbox



-----
## Blank
[☝](#Topics-Covered)
