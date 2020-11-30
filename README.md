# Simple Dictum Demo

## Overview

This demo uses a Terraform demo provided by Hashicorp to demonstrate
how Dictum-SM manages infrastructure. The link to the original demo can be found [here](https://learn.hashicorp.com/tutorials/terraform/eks)

The following components are deployed in this demo:

1. AWS VPC and EKS cluster
2. kubernetes metrics server
3. kubernetes dashboard

## Prereqs

1. The following programs need to be available to the shell of the user running Dictum-SM:

- yq
- kubectl
- terraform
- aws cli
- AWS IAM Authenticator
- wget
- Dictum CLI

2. AWS cli needs to be configured. Make sure that the output format is json (as seen [here](https://learn.hashicorp.com/tutorials/terraform/eks#prerequisites))

## Create

Follow these steps to deploy the demo environment:

1. Create a new directory for your workspace root:  

    `mkdir dictum-demo && cd "$_"`

2. Initialize the Dictum workspace:  

    `dictum-cli init`

3. Create subdirectories:  

    `mkdir -p {terraform/eks-vpc,kubernetes/{metrics-server,dashboard}}`

4. Download Terraform configs:

   `wget -P terraform/eks-vpc/ -i https://raw.githubusercontent.com/Dictum-SM/demo/main/terraform/eks-vpc/files.txt`

5. Download the metrics server configs:  

   `wget -P kubernetes/metrics-server/ -i https://raw.githubusercontent.com/Dictum-SM/demo/main/kubernetes/metrics-server/files.txt`

6. Download the Dashboard configs:  

   `wget -P kubernetes/dashboard/ -i https://raw.githubusercontent.com/Dictum-SM/demo/main/kubernetes/dashboard/files.txt`

7. Download the kube-context helper script:

    `wget -P utilities/scripts/ https://raw.githubusercontent.com/Dictum-SM/demo/main/utilities/scripts/set-kube-context.sh`

8. Open the State file for editing:

   `dictum-cli define`

9. Under the `data:` section, remove the example kv pairs and add the following in order:

```
  aws-eks-vp-terraform: "terraform/eks-vpc/"
  set-kube-context-bash: "utilities/scripts/set-kube-context.sh"
  metrics-server-kubectlf: "kubernetes/metrics-server/"
  k8s-dashboard-kubectlk: "kubernetes/dashboard/"
```
*Note*: Mind your yaml spacing.  
*Note*: Type `i` to edit and `<esc> :wq!` to save and close.

10. Run Dictum-SM to deploy the environment and wait for completion:

   `dictum-cli run`

   *Note:* Hashicorp says that this takes 10min. I guestimate closer to 15. YMMV.

11. View your cluster:

    `kubectl get pods -A`

12. Get dashboard token and save for later:

    `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')`

13. Create your the proxy:

    `kubectl proxy`

14. From your browser, browse to dashboard:

    `http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

15. Select token authentication, input the token retrieved by step 11, and login.


## Manage

Let's pretend that we dont want the dashboard to be deployed into our environment anymore.

1. Open the State file for editing:

    `dictum-cli define`

2. Remove the following kv pair:

    `k8s-dashboard-kubectlk: "kubernetes/dashboard/"`

    *Note*: With your cursor on the line with the referenced kv pair, type `dd` to delete the entire line.  
    *Note*: Type `<esc> :wq!` to save and close

3. Run Dictum-SM

    `dictum-cli run`

4. Verify that the dashboard has been deleted:

   `kubectl get pods -A`

## Destroy Environment

EKS is expensive. Let's tear it down.

1. Prepare the workspace to delete the environment
   `dictum-cli prep-delete`

2. Destroy the environment

   `dictum-cli run`  

*Note*: Terraform occasionally destroys resources out of the order that AWS requires. If the terraform destroy action is coming up on its timeout of 20 min, you may need to perform a detatch on the demo elastic IP from the AWS console so that terraform destroy can succeed. Also make sure that you release the IP when the VPC is destroyed.

3. Return the workspace to normal

   `dictum-cli reset`






