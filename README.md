# OCVS_VM_Deploy
Deploying OCVS VM's using OCI vault secrets for credentials
In this Repo , i am going to deploy VM's on OCVS(Oracle Cloud Vmware solution) which is first class citizen on OCI. For deployment we often need to pass vCenter credentials which is either encrypted using third party tools or plain text.
Here i am going to leverage OCI Vault secrets to pass vcenter credentials during Terraform deployment. Access to OCI_Vault_secrets is secure and only authorized users can access it.
For more details check this blog : https://asknikhil.com
where i am talking about how to create Vault secret , Leverage OCI terraform modules to get that credentials and later pass these in Terraform VMware modules.
