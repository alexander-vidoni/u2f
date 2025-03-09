# u2f# U2F-Authentifizierung mit YubiKey unter Ubuntu

Dieses Projekt automatisiert die Einrichtung der U2F-Authentifizierung mit einem YubiKey unter Ubuntu mithilfe von Ansible.  Es bietet ein bequemes Shell-Skript, um die Installation von Ansible zu vereinfachen und die Konfiguration zu starten.

## Voraussetzungen

*   Ein YubiKey oder ein anderes U2F-kompatibles Gerät.
*   Ein Ubuntu-System (dieses Skript wurde für Ubuntu getestet, sollte aber auch auf Derivaten funktionieren).
*   Eine Internetverbindung zum Herunterladen von Paketen.

## Installation

1.  **Skript herunterladen:**

    Verwende `wget` oder `curl`, um das `setup-yubikey.sh`-Skript von diesem GitHub-Repository herunterzuladen:

    ```
    wget https://raw.githubusercontent.com/alexander-vidoni/u2f/main/setup-yubikey.sh
    # ODER
    curl -O https://raw.githubusercontent.com/alexander-vidoni/u2f/main/setup-yubikey.sh
    ```

2.  **Skript ausführbar machen:**

    Mache das heruntergeladene Skript ausführbar:

    ```
    chmod +x setup-yubikey.sh
    ```

3.  **Skript ausführen:**

    Führe das Skript mit `sudo` aus, um die Installation und Konfiguration zu starten.  Du wirst aufgefordert, dein Passwort einzugeben:

    ```
    sudo ./setup-yubikey.sh
    ```

    Das Skript führt folgende Schritte aus:

    *   Aktualisiert die Paketliste.
    *   Installiert erforderliche Pakete für Ansible.
    *   Fügt das Ansible PPA hinzu.
    *   Installiert Ansible.
    *   Klonen dieses Repositorys in ein temporäres Verzeichnis (`/tmp/ansible-repo`).
    *   Führt das Ansible Playbook (`ubuntu.yml`) aus, um die U2F-Authentifizierung zu konfigurieren.

## Konfiguration

Das Ansible Playbook automatisiert die folgenden Schritte:

*   Installiert `libpam-u2f`.
*   Erstellt das `.config/Yubico`-Verzeichnis in deinem Home-Verzeichnis.
*   Generiert die U2F-Schlüsseldatei (`~/.config/Yubico/u2f_keys`) mit `pamu2fcfg`. **Während der Ausführung von `pamu2fcfg` musst du deinen YubiKey einstecken und den Metallkontakt berühren, wenn er blinkt.**
*   Konfiguriert `sudo`, `gdm-password` (für Ubuntu 17.10+), `lightdm` (für Ubuntu < 17.10) und `login` (TTY-Terminal), um die U2F-Authentifizierung zu verwenden.

## Variablen

Das Playbook verwendet die folgenden Variablen, die du anpassen kannst:

*   `move_u2f_keys_to_etc`:  Wenn auf `true` gesetzt, wird die U2F-Schlüsseldatei nach `/etc/Yubico/u2f_keys` verschoben.  **WARNUNG:** Dies kann zu Problemen führen, wenn dein Home-Verzeichnis verschlüsselt ist.
*   `enable_debug_mode`: Wenn auf `true` gesetzt, wird der Debug-Modus für das `pam_u2f`-Modul aktiviert.
*   `add_backup_key`: Wenn auf `true` gesetzt, wirst du aufgefordert, einen zusätzlichen YubiKey als Backup-Gerät zu registrieren.
*   `enable_pin`: Wenn auf `true` gesetzt, wird die PIN-Abfrage für die U2F-Authentifizierung aktiviert. **Dies erfordert eine YubiKey mit konfigurierter PIN.**

Um diese Variablen zu ändern, bearbeite die Datei `ubuntu.yml` in diesem Repository, bevor du das Skript ausführst.

## Nach der Installation

*   **Testen:**  Teste die U2F-Authentifizierung sorgfältig, insbesondere mit `sudo`, bevor du dich abmeldest oder das System neu startest.
*   **Backup:** Stelle sicher, dass du eine Möglichkeit hast, dich anzumelden, falls die U2F-Authentifizierung fehlschlägt (z. B. ein Backup-Benutzer mit Passwort-Authentifizierung).

## Troubleshooting

*   **Debug-Modus:**  Wenn du Probleme hast, aktiviere den Debug-Modus, indem du `enable_debug_mode` in der `ubuntu.yml`-Datei auf `true` setzt.  Die Debug-Informationen werden in `/var/log/pam_u2f.log` gespeichert.
*   **PAM-Konfiguration:**  Überprüfe die PAM-Konfigurationsdateien (`/etc/pam.d/sudo`, `/etc/pam.d/gdm-password`, `/etc/pam.d/lightdm`, `/etc/pam.d/login`), um sicherzustellen, dass die U2F-Authentifizierung korrekt konfiguriert ist.
*   **Verschlüsseltes Home-Verzeichnis:** Wenn dein Home-Verzeichnis verschlüsselt ist, kann es zu Problemen kommen, wenn du die U2F-Schlüsseldatei nach `/etc/Yubico` verschiebst.  In diesem Fall solltest du die Schlüsseldatei im Home-Verzeichnis belassen.

## Deinstallation

Um die U2F-Authentifizierung zu deaktivieren, musst du die Änderungen an den PAM-Konfigurationsdateien rückgängig machen und das `libpam-u2f`-Paket deinstallieren.

## Sicherheitshinweise

*   Stelle sicher, dass du eine Möglichkeit hast, dich anzumelden, falls die U2F-Authentifizierung fehlschlägt.
*   Bewahre deinen YubiKey sicher auf.
*   Aktiviere die PIN-Abfrage für zusätzliche Sicherheit.

## Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert.

