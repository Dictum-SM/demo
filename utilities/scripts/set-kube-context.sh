#!/bin/bash -xv

cd ${WORKDIR}/terraform/eks-vpc
aws eks --region $(terraform output region) update-kubeconfig --name $(terraform output cluster_name)
cd -