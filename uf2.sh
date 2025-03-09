#!/bin/bash
set -e

# 1. Ansible installieren
echo "Aktualisiere Paketliste..."
sudo apt-get update

echo "Installiere erforderliche Pakete..."
sudo apt-get install -y software-properties-common apt-transport-https

echo "Füge Ansible PPA hinzu..."
sudo add-apt-repository --yes --update ppa:ansible/ansible

echo "Installiere Ansible..."
sudo apt-get install -y ansible

# 2. GitHub-Repository und Playbook-Download
REPO_URL="https://github.com/alexander-vidoni/u2f"
PLAYBOOK_PATH="./ubuntu.yml" # Relativer Pfad zum Playbook

echo "Lade das Ansible Playbook herunter..."
if ! git clone "$REPO_URL" /tmp/ansible-repo; then
  echo "Fehler beim Klonen des Repository!"
  exit 1
fi

# 3. Ansible Playbook ausführen
echo "Führe Ansible Playbook aus..."
cd /tmp/ansible-repo
sudo ansible-playbook "$PLAYBOOK_PATH" -K

echo "Fertig!"

# Optionale Aufräumarbeiten
# rm -rf /tmp/ansible-repo

