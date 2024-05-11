kbh(1) ["Version -git"]

# NAME

kbh - Krathalan's Borg Helper

# SYNOPSIS

kbh *[SUBCOMMAND]* _[args]_

# DESCRIPTION

kbh is a terminal program that uses the borg backup tool to create and manage multiple encrypted borg repositories and archives easily and quickly. kbh provides borg with specified passkey commands to skip password inputs, and you can refer to your repositories with your own easy-to-remember names.

You must have a configuration file specifying backup and repository information. All commands will use information from this configuration file. See *CONFIG FILE* below for more information.

# SUBCOMMANDS

*status*, *--status*
	Displays the current configuration of kbh and the configuration and status of all defined repositories. 

*backup*, *--backup*
	Creates a full borg backup of all backup path directories to all repositories.

	e.g. kbh *backup*

*info*, *--info*, *repo-info*, *--repo-info*
	Displays the repository information ("borg info ...") for all repositories. Optionally you may specify a repository to display information only for that repository.

	e.g. kbh *info*++
e.g. kbh *info* _home-server_

*list*, *list-archives*, *-l*, *--list*, *--list-archives*
	Lists all archives ("borg list ...") in all repositories. Optionally you may specify a repository to list archives only from that repository.

	e.g. kbh *list*++
e.g. kbh *list* _home-server_

*mount*, *mount-archive*, *-m*, *--mount*, *--mount-archive*
	Mounts an archive from a specified repository or the full repository. If no mount point is defined in the configuration file, *mount* will default to /mnt/borg. You may override the mount point with the environment variable KBH_MOUNTPOINT. If no archive is given, *mount* will mount the entire repository.

	e.g. kbh *mount* _home-server_++
e.g. kbh *mount* _home-server May-02-2024-14-23-22_

*init*, *init-repos*, *--init*, *--init-repos*
	Creates all repositories as defined in the configuration file. kbh will encrypt all repositories with "--encryption repokey-blake2" and prompt for a key. Afterwards, kbh will display the output of "borg key export ..." for every repository created.

	e.g. kbh *init*

*prune*, *-p*, *--prune*
	Prunes either a specified repository or, if no repository specified, all repositories according to the configuration's prune command. If no prune command is specified, *prune* will default to "borg prune -v --list --keep-daily=7 --keep-weekly=-1". This command will keep the latest backup on each day, up to 7 most recent days with backups, in addition to keeping the latest backup from each week for all time (no limit on weekly backups).++
  After pruning, kbh will run "borg compact" to free up disk space.

	e.g. kbh *prune*++
e.g. kbh *prune* _home-server_

# CONFIG FILE

Config file at ~/.config/krathalan/kbh.json is read for program settings and repo information. kbh will respect XDG dir settings. The full path kbh uses for finding the config file is "\${XDG_CONFIG_HOME:-\${HOME}/.config}/krathalan/kbh.json".

You must define an array of borg repositories (.repos[]) with each specifying the name (.repos[X].name) and repo path (.repos[X].path).++
You must include alternative names (.repos[X].alternative_names[]) as an array of alternative names you may use to refer to the same repo for various kbh commands. If you have no alternative names, you must still create an empty array for kbh to work properly.++
Optionally you may specify a command to output your repo key for that specific repo (.repos[X].password_command), for skipping password checks.++
Optionally you may specify the compression algorithm (.repos[X].compression) that you would like to use for new archives for that repo.

Optionally you may specify a path for the mount point of the *kbh mount ...* command (.mount_point). If not specified, the value defaults to "/mnt/borg". This value may be overriden with the use of the KBH_MOUNTPOINT environment variable.

Optionally you may specify a command for how you would like kbh to name new archives (.borg_archive_name_command). For example, you may specify custom date commands. If not specified, the value defaults to "date +%Y-%m-%d-%H%M%S" which looks something like "2024-05-06-204905".

Optionally you may specify a command to copy your password for the local ssh key (.ssh_key_password_copy_command), if you are accessing repos over ssh. kbh will check the output of the *ssh-add -L* command; if no key is present, then *ssh-add* will be ran with no arguments.

Here is an example configuration file:

	_~/.config/krathalan/kbh.json_
```
{
  "borg_archive_name_command": "date +%Y-%m-%d-%H%M%S",
  "ssh_key_password_copy_command": "pash c cryptkeys/ssh-desktop",
  "mount_point": "/mnt/borg",
  "backup_paths": ["/home/anders/documents", "/home/anders/pictures"],
  "repos": [
    {
      "name": "alpha",
      "alternative_names": [],
      "path": "ssh://anders@192.168.1.2:44369/home/anders/borg",
      "password_command": "pash s cryptkeys/borg-alpha"
    },
    {
      "name": "email",
      "alternative_names": ["email-server", "krathalan.net", "server"],
      "path": "ssh://admin@krathalan.net:44369/mnt/borg-backup/borg",
      "password_command": "pash s cryptkeys/borg-email"
      "compression": "zstd,17"
    }
  ]
}
```

# BUGS

Please file requests and report any bugs at: https://github.com/krathalan/miscellaneous-scripts

*If you are reporting a bug, please attach a debug log.*

To create a debug log, run kbh like so:

bash -x kbh [your command] &> kbh-debug.log

# LICENSES

kbh itself is licensed under the GPLv3.

## Dependencies

jaq is licensed under the MIT ("Expat") license.

Borg is licensed under the 3-clause ("Modified") BSD license.

All licenses, for kbh itself and its dependencies, are verified by the FSF to be free software licenses and compatible with the GNU GPL: https://www.gnu.org/licenses/license-list.html