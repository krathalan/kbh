# kbh
**K**rathalan's **B**org **H**elper

WARNING: IN DEVELOPMENT, all Readme/man page info may NOT match what the code actually does!!!

JSON-based, config-driven manager for easily managing multiple borg repositories. You define paths to backup, repositories with individual BORG_PASSPHRASE and compression settings, and more.

## Features

kbh lets you refer to your repositories using the repository names you have defined in your configuration. One repository can be referred to with multiple different names (see `alternative_names` in the config example below). kbh will use the configured password command for each repo to skip password prompts. 

Instead having to put in your password and remember to type:

```
$ borg create --compression zstd,10 --stats --progress "ssh://user@some.ip:port/path/to/repo::$(date +%some-%weird-%cmd)" /multiple/backup /paths/to/backup
```

You can type:

```
$ kbh backup reponame
```

Continuing the example, the config for the above command would look something like:

```
{
  "borg_archive_name_command": "date +%some-%weird-%cmd",
  "ssh_key_password_copy_command": "pass c ssh-password",
  "mount_point": "/mnt/borg",
  "backup_paths": ["/multiple/backup", "/paths/to/backup"],
  "repos": [
    {
      "name": "reponame",
      "alternative_names": ["reponame-main"],
      "path": "ssh://user@some.ip:port/path/to/repo",
      "password_command": "pass s borg-reponame",
      "compression": "zstd,10"
    }
  ]
}
```

### Subcommands

Implements most common borg subcommands as the same subcommand name, such as:
- init
- create (`kbh backup`)
- info
- list
- mount
- prune

Additional kbh-only commands:
- status
- help

Most kbh commands will work either with no arguments (performs subcommand on all repos) or by specifying repo (and optionally archive for some commands, like `kbh mount`).

See the [`man page`](kbh.1.scd) for more information, including usage examples, flags and override variables, configuration file information and examples, and more.

## Sanity checking

kbh will attempt to sanity check most commands -- for example, `kbh mount` will check to make sure (1) your mount directory exists, and (2) that something isn't already mounted on that directory.

However, apart from ensuring your configuration is a valid JSON file, kbh will NOT attempt to sanity check any of the values you have put in. For example, kbh will NOT check the names you have defined for your repositories are unique. For example, if you have two repositories with the same name or two repositories which share an alternative name, 

## Install

Arch PKGBUILD in my personal repo: https://github.com/krathalan/pkgbuilds