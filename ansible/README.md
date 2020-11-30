# Ansible

## Playbook Structure
DSM's native ansible support requires playbooks to be written with a very prescriptive methodology.
Playbooks to be executed by DSM must include main plays that are conditinally run with either the "operation=apply" or "operation=delete" variables. The play executed when the "operation=delete" variable is present should undo any configurations performed by the play executed when the operation=apply variable is present. 

# When to Use New Resources
Special consideration should be made when determining when to mutate a configuration parameter managed by ansible vice when to delete and add a new parameter. Modules such as lineinfile may require deletion and creation of new parameters to preseve the inegrity of subsequent deletions.

For example:

If new lines are added to an HAProxy config in the first run of DSM, but those lines are changed in subsequent runs, when a delete operation is performed, it will only delete the lines created by the last apply operation and all other DSM added lines will persist in the environment. 

Avoid this behavior by limiting the scope of playbooks and adding a new playbook to manage each scoped configuration.

# Workspace Structure

It is generally easiest to dump all roles into the <workspace>/ansible/roles directory and them call them as modules from playbooks in the <workspace>/ansible/playbooks directory. 