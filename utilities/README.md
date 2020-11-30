# Utilities

DSM has native support for two types of utilities:

- Scripts (non-configuring)
- Secrets

# Scripts

Scripts are executed by DSM to perform non-configuring tasks such as:

- Healthchecking between declarative operations
- Unlocking secrets
- Changing the default namespace of the current user's kube context as a prepatory action for helm installs.

Scripts should never perform configuration actions and DSM has no mechanism for executing scripts as a delete operation.

# Secrets

It may be preferable at times to store secrets in a DSM workspace. These should be encrypted with something like ansible vault and then unlocked at DSM runtime by the script executor. Take special care if using this workflow. Depending on the decryption mechanism, decrypted secrets may remain decrypted after DSM has run. This behavior can be avoided by once again using the script executor to re-encrypt the secret once the secret is no longer needed by the DSM runtime. 
