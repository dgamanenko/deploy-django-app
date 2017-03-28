#!/bin/bash
ansible-playbook -c local -i ",localhost" deploy.yml --vault-password-file ./.vault_pass.txt
