Create Master profile
--------------------
- aws iam create-role --role-name kubespray-master --assume-role-policy-document file://kubernetes-master-role.json
- aws iam put-role-policy --role-name kubespray-master --policy-name kubeSprayMasterPolicy --policy-document file://kubernetes-master-policy.json
- aws iam create-instance-profile --instance-profile-name kubeSprayMasterPolicy
- aws iam add-role-to-instance-profile --role-name kubespray-master --instance-profile-name kubeSprayMasterPolicy

Create Worker/Minion profile
----------------------------
- aws iam create-role --role-name kubespray-worker --assume-role-policy-document file://kubernetes-minion-role.json
- aws iam put-role-policy --role-name kubespray-worker --policy-name kubeSprayWorkerPolicy --policy-document file://kubernetes-minion-policy.json
- aws iam create-instance-profile --instance-profile-name kubeSprayWorkerPolicy
- aws iam add-role-to-instance-profile --role-name kubespray-worker --instance-profile-name kubeSprayWorkerPolicy
