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

2. AWS cli needs to be configured. Make sure that the output format is json.

## Process

1. Create a new directory to be your workspace root:

    `mkdir dictum-demo && cd "$_"`

2. Initialize the Dictum workspace

    `dictum-cli init`

3. Create subdirectories

    `mkdir -p {terraform/eks-vpc,kubernetes/{metrics-server,dashboard}}`

4. Download 


