# TemplateManagement
A template management project spread across Openstack, vCloud, Proxmox, Hyper-v

The project involves using GitLAB CI/CD with specific runners that can be called through tags to parallelize workflows based on the environment and requirements.
The runners will be installed in specific service VMs containing programs to manage VMs and templates such as Hashicorp Packer and Terraform, as well as programs to remotely launch commands such as Ansible and Python.
The focus of the solution will be on using and generating templates for virtual and physical environments as much as possible in an automated manner without human intervention.
Each GitLAB project will contain a series of files and variables that will be used to maintain the pipeline to keep the templates up to date for both programs and security policies.
Specifically for the physical world, in addition to integration with the current solution, integration with Canonical's solution called MAAS is being evaluated, which involves using custom ISOs through Hashicorp Packer, a very similar implementation to the virtual world solution compared to the current Fog Project solution, which involves physically installing a host and then capturing the image.

![immagine](https://user-images.githubusercontent.com/34857243/237058290-344ccc76-7ccd-4e4d-b3a0-2c3cc9ef0461.png)
