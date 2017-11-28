# Ansible Deployment Scripts

Ansible on the local machine should be at version 2.2+. The stack is pretty basic:

- CentOS 7.4

There are two supported environments: `dev` and `prod`. These are specified through the `app_env` variable in the inventory files (`hosts_<env>` in the `ansible` directory).

## Local development using VMs

See `dev-scripts/README`, or you can use Vagrant / VirtualBox / etc to set up your own virtual machines.

```bash
# first run only
$ ansible-playbook -i hosts_dev playbooks/create-deploy-user.yaml

# full provision & deploy
$ ansible-playbook -i hosts_dev playbooks/main.yaml
```

## Deployment to production

Update `ansible/hosts_prod` to reflect your desired deployment destination.

Create the `ansible/secrets.yaml` file:

```bash
$ cd ansible
$ ansible-vault create secrets.yaml
```

At a minimum, you will want to define the following variables:

```yaml
---
```
