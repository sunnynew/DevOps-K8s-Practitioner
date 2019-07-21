Install Kubernetes cluster
-------------------------
We will use kubespray to setup k8s cluster, given script will 

1). Install k8s

2). Use dynamic inventory

3). Configure kubectl

Just run 

- sh kubespray-setup.sh

Enable PV dynamic provisioning/Default Storage Class
----------------------------------------------------
Dynamic provisioning of PV and PVC are required by different applications we deploy in this kubernetes cluster.
So, defining default StorageClass.

 - kubectl create -f storageclass.yaml
