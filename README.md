# Iac
Duo Iac porject top1

## Pré-requis
- Python 3.112.x min
- OpenTofu (sudo snap install tofu --classic)
- Compte cloud OVH
- clés SSH
- Docker
- Ansible



## Get started
- git clone https://github.com/kangnii/Iac.git
- cd Iac/
- python3 -m venv .venv
- python3 .venv/bin/activate
- pip install requirements.txt
- source ./openrc-etudiant.sh
- tofu init
- tofu plan
- tofu apply
- ansible-playbook -i inventory.ini playbook.yaml


