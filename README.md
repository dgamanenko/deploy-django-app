python
=============

[![Build Status](http://img.shields.io/travis/Stouts/python.svg?style=flat-square)](https://travis-ci.org/Stouts/python)
[![Galaxy](http://img.shields.io/badge/galaxy-python-blue.svg?style=flat-square)](https://galaxy.ansible.com/list#/roles/910)

Ansible role which manage python's versions (pip, virtualenv)

#### Variables

```yaml
---

python_enabled: yes                 # The role is enabled
python_ppa: ppa:fkrull/deadsnakes   # Python PPA
python_versions: [2.7, 3.4]         # Set versions (2.6, 2.7, 3.3, 3.4) which will be installed

python_install: []                  # Set packages to install globally
python_virtualenvs: []              # Create virtualenvs
                                    # Ex: python_virtualenvs:
                                    #     - path: /path/to/venv
                                    #     - path: /path/to/another/venv
                                    #       python: python3.4


python_bin: /usr/bin/python
python_pkg_bin: /usr/local/bin
python_yum_disablerepo: no
python_yum_enablerepo: no
```

#### Usage

Add `python` to your roles and set vars in your playbook file.

Example:

```yaml

- hosts: all

  roles:
    - python

  vars:
    python_versions: [2.7, 3.3]
    python_install: [django, gunicorn]
    python_virtualenvs:
    - path: /home/django/myproject/env
```

If you want the virtualenv directories to be owned by a specific user

```yaml

- hosts: all

  roles:
    - python

  vars:
    python_versions: [2.7, 3.3]
    python_install: [django, gunicorn]
    python_virtualenvs:
    - path: /home/django/myproject/env
    python_virtualenv_user: "deployment"
```


#### License

Licensed under the MIT License. See the LICENSE file for details.

#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Stouts/python/issues)!
Postgresql Role 
==================

Installs and configure Postgresql 9.6.

Role Variables
--------------

The variables that can be passed to this role and a brief description about them are as follows:
	
   ```postgresql_version```: Version to install (see which supports in /meta/main.wml).<br /> 
   ```postgresql_service_name```: Service name. <br />
	```db_name```: Database name. <br />
	```create_db```: Whether or not create database "db_name". <br />
   ```root_user```: Name and password of database user. <br /><br />
   Default values:
```yml
  postgresql_version: 9.6
  postgresql_service_name: postgresql
  db_name: database
  create_db: yes
  root_user:
      name: postgres
      password: default,	
```

Example Playbook
----------------


```yml
  roles:
    - { role: 'serlophug.postgresql'}
```


License
-------

Apache Licence v2 [1]

[1] http://www.apache.org/licenses/LICENSE-2.0

deploy
=============

[![Build Status](http://img.shields.io/travis/Stouts/deploy.svg?style=flat-square)](https://travis-ci.org/Stouts/deploy)
[![Galaxy](http://img.shields.io/badge/galaxy-deploy-blue.svg?style=flat-square)](https://galaxy.deploy.com/list#/roles/933)
[![Tag](http://img.shields.io/github/tag/Stouts/deploy.svg?style=flat-square)]()

Ansible role which creates deploy directories and sets deploy variables, also ensures for deploy user exists
The Boilerplate for using in playbooks and other roles.


#### Variables

The role variables and default values.

```yaml
deploy_enabled: yes                           # Enable the role

deploy_env: develop                           # Pick environment variable

deploy_user: "{{ansible_ssh_user}}"           # Set deploy user
deploy_group: "{{deploy_user}}"               # Set deploy group

deploy_app_name: web                          # Set application name

deploy_dir: /usr/lib/{{deploy_app_name}}      # Root deploy directory
deploy_etc_dir: "{{deploy_dir}}/etc"          # Directory where placed configuration files
deploy_log_dir: "{{deploy_dir}}/log"          # Directory where placed logs
deploy_run_dir: "{{deploy_dir}}/run"          # Directory where placed unix sockets and pid files
deploy_src_dir: "{{deploy_dir}}/src"          # Source's directory
deploy_bin_dir: "{{deploy_dir}}/bin"          # Directory where placed scripts

deploy_dir_skip: ["{{deploy_src_dir}}", "{{deploy_bin_dir}}"]       # Dont create this dirs, only keep variables
```

#### Usage

Add `deploy` to your roles and set variables in your playbook file.

Example:

```yaml

- hosts: all

  roles:
    - deploy

  vars:
    deploy_app_name: facebook  # ;)
    deploy_user: deploy
```

#### License

Licensed under the MIT License. See the LICENSE file for details.

#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Stouts/deploy/issues)!
backup
=============

[![Build Status](http://img.shields.io/travis/Stouts/backup.svg?style=flat-square)](https://travis-ci.org/Stouts/backup)
[![Galaxy](http://img.shields.io/badge/galaxy-backup-blue.svg?style=flat-square)](https://galaxy.ansible.com/list#/roles/945)

Ansible role which manage backups. Support file backups, postgresql, mysql, mongo db backups.


## Variables

The role variables and default values.

```yaml
backup_enabled: yes             # Enable the role
backup_remove: no               # Set yes for uninstall the role from target system
backup_cron: yes                # Setup cron tasks for backup

backup_user: root               # Run backups as user
backup_group: "{{backup_user}}"

backup_home: /etc/duply         # Backup configuration directory
backup_work: /var/duply         # Working directory

backup_duplicity_ppa: ppa:duplicity-team/ppa  # Set empty for skipping PPA addition
backup_duplicity_pkg: duplicity
backup_duplicity_version:       # Set duplicity version

# Logging
backup_logdir: /var/log/duply   # Place where logs will be keepped
backup_logrotate: yes           # Setup logs rotation

# Posgresql
backup_postgres_user: postgres
backup_postgres_host: ""

# Mysql
backup_mysql_user: mysql
backup_mysql_pass: ""

backup_profiles: []           # Setup backup profiles
                              # Ex. backup_profiles:
                              #       - name: www               # required param
                              #         schedule: 0 0 * * 0     # if defined enabled cronjob
                              #         source: /var/www
                              #         max_age: 10D
                              #         target: s3://my.bucket/www
                              #         params:
                              #           - "BEST_PASSWORD={{ best_password }}"
                              #         exclude:
                              #           - *.pyc
                              #       - name: postgresql
                              #         schedule: 0 4 * * *
                              #         action: restore         # Choose action: backup/restore (default is backup)
                              #         source: postgresql://db_name
                              #         target: s3://my.bucket/postgresql

# Default values (overide them in backup profiles bellow) 
# =======================================================
# (every value can be replaced in jobs individually)

# GPG
backup_gpg_key: disabled
backup_gpg_pw: ""
backup_gpg_opts: ''

# TARGET
# syntax is
#   scheme://[user:password@]host[:port]/[/]path
# probably one out of
#   file://[/absolute_]path
#   ftp[s]://user[:password]@other.host[:port]/some_dir
#   hsi://user[:password]@other.host/some_dir
#   cf+http://container_name
#   imap[s]://user[:password]@host.com[/from_address_prefix]
#   rsync://user[:password]@other.host[:port]::/module/some_dir
#   rsync://user@other.host[:port]/relative_path
#   rsync://user@other.host[:port]//absolute_path
#   # for the s3 user/password are AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY
#   s3://[user:password]@host/bucket_name[/prefix]
#   s3+http://[user:password]@bucket_name[/prefix]
#   ssh://user[:password]@other.host[:port]/some_dir
#   tahoe://alias/directory
#   webdav[s]://user[:password]@other.host/some_dir
backup_target: 'file:///var/backup'
# optionally the username/password can be defined as extra variables
backup_target_user:
backup_target_pass:

# Time frame for old backups to keep, Used for the "purge" command.  
# see duplicity man page, chapter TIME_FORMATS)
backup_max_age: 1M

# Number of full backups to keep. Used for the "purge-full" command. 
# See duplicity man page, action "remove-all-but-n-full".
backup_max_full_backups: 1

# forces a full backup if last full backup reaches a specified age
backup_full_max_age: 1M

# set the size of backup chunks to VOLSIZE MB instead of the default 25MB.
backup_volsize: 50

# verbosity of output (error 0, warning 1-2, notice 3-4, info 5-8, debug 9)
backup_verbosity: 3

backup_exclude: [] # List of filemasks to exlude
```

## Usage

Add `backup` to your roles and set variables in your playbook file.

Example:

```yaml

- hosts: all

  roles:
    - backup

  vars:
    backup_target_user: aws_access_key
    backup_target_pass: aws_secret
    backup_profiles:

    # Backup file path
    - name: uploads                               # Required params
        schedule: 0 3 * * *                       # At 3am every day
        source: /usr/lib/project/uploads
        target: s3://s3-eu-west-1.amazonaws.com/backup.backet/{{inventory_hostname}}/uploads

    # Backup postgresql database
    - name: postgresql
        schedule: 0 4 * * *                       # At 4am every day
        source: postgresql://project              # Backup prefixes: postgresql://, maysql://, mongo://
        target: s3://s3-eu-west-1.amazonaws.com/backup.backet/{{inventory_hostname}}/postgresql
        user: postgres

```

### Manage backups manually

Run backup for profile `uploads` manually:

    $ duply uploads backup

Load backup for profile `postgresql` from cloud and restore database (logged as postgres user)

    $ duply postgresql restore

Also see `duply usage`


## License

Licensed under the MIT License. See the LICENSE file for details.

## Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Stouts/backup/issues)!

If you wish to express your appreciation for the role, you are welcome to send
a postcard to:

    Kirill Klenov
    pos. Severny 8-3
    MO, Istra, 143500
    Russia
wsgi
===========

[![Build Status](http://img.shields.io/travis/Stouts/wsgi.svg?style=flat-square)](https://travis-ci.org/Stouts/wsgi)
[![Galaxy](http://img.shields.io/badge/galaxy-wsgi-blue.svg?style=flat-square)](https://galaxy.ansible.com/list#/roles/831)

Ansible role which deploys wsgi application (uwsgi/gunicorn, nginx, virtualenv)

* Install and setup nginx, uwsgi/gunicorn;
* Setup and manage project requirements and virtualenv;
* Deploy project with wsgi/gunicorn, enable monitoring;
* Support multiple WSGI applications;


#### Requirements & Dependencies

- [python](https://github.com/Stouts/python)
- [nginx](https://github.com/Stouts/nginx)


#### Variables

The role variables and default values.

```yaml
wsgi_enabled: yes                                     # Enable the role

wsgi_user: "{{deploy_user|default(ansible_user)}}"    # An user to run WSGI applications
wsgi_group: "{{deploy_group|default(wsgi_user)}}"     # A group to run WSGI applications
wsgi_server: uwsgi                                    # A server which provide wsgi integration (uwsgi/gunicorn)
wsgi_proxy: nginx                                     # A proxy http server (nginx)
wsgi_proxy_params: |
  proxy_set_header  X-Real-IP  $remote_addr;
  proxy_set_header Host $http_host;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
wsgi_reload: no                                       # Reload servers when code changes

wsgi_pip_packages: []                                 # Pip packages to install

wsgi_applications:                                    # Setup your wsgi application here
- name: "{{deploy_app_name|default('wsgi')}}"

# Default virtualenv options
wsgi_virtualenv: "{{deploy_dir|default('/home/django/wsgi')}}/env"
wsgi_virtualenv_python: python

wsgi_service: upstart

# UWSGI default options (can be redefined for each wsgi app)
wsgi_uwsgi_enable_threads: no
wsgi_uwsgi_read_timeout: 300
wsgi_uwsgi_processes: 4
wsgi_uwsgi_max_requests: 2000
wsgi_uwsgi_no_orphans: yes
wsgi_uwsgi_options: []

# Gunicorn default options (can be redefined for each wsgi app)
wsgi_gunicorn_command: gunicorn
wsgi_gunicorn_worker: sync
wsgi_gunicorn_workers: 4

# Nginx default options (can be redefined for each wsgi app)
wsgi_nginx_port: 80                                   # Default port to listen
wsgi_nginx_redirect_www: no                           # Redirect www.servername to servername
wsgi_nginx_options: []
wsgi_nginx_servernames: "{{inventory_hostname}}"      # Listen servernames (separated by space)
wsgi_nginx_ssl: no                                    # Set yes to enable SSL
wsgi_nginx_ssl_protocols: TLSv1 TLSv1.1 TLSv1.2       # Enabled SSL protocols
wsgi_nginx_ssl_crt:                                   # Path to certificate bundle
wsgi_nginx_ssl_key:                                   # Path to certificate key
wsgi_nginx_ssl_port: 443
wsgi_nginx_ssl_redirect: no                           # Redirect to SSL port
wsgi_nginx_static_locations: [/static/, /media/]

# Logging options
wsgi_log_rotate: yes                                   # Rotate wsgi logs.
wsgi_log_rotate_options:
- "create 644 {{wsgi_user}} {{wsgi_group}}"
- compress
- copytruncate
- daily
- dateext
- rotate 7
- size 10M
```

#### Usage

Clone dependencies.
Add `wsgi` to your roles and change variables in your playbook file.

Example:

```yaml

- hosts: all

  roles:
  - wsgi

  vars:
    wsgi_applications:
    - name: facebook
        nginx_servernames: www.facebook.com facebook.com
        file: /home/django/facebook/wsgi.py
    - name: twitter
        server: gunicorn
        nginx_servernames: twitter.com
        module: twitter:app
```

#### License

Licensed under the MIT License. See the LICENSE file for details.


#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Stouts/wsgi/issues)!
source
=============

[![Build Status](http://img.shields.io/travis/Stouts/source.svg?style=flat-square)](https://travis-ci.org/Stouts/source)
[![Galaxy](http://img.shields.io/badge/galaxy-source-blue.svg?style=flat-square)](https://galaxy.ansible.com/list#/roles/851)
[![Tag](http://img.shields.io/github/tag/Stouts/source.svg?style=flat-square)]()

Ansible role wich manage sources from git or mercurial repositoires.

The role is allowing you to clone sources from git or mercurial repositories to
your servers and run handlers when it was updated.

#### Variables
```yaml
source_enabled: yes                   # Enable role
source_sources: []                    # Repositories to clone
                                      # Define your sources here
                                      # Ex: source_sources:
                                        #   - repo: git@github.com:my/repo1.git
                                        #     dest: /some/destination/path
                                        #     version: develop
                                        #     handlers:
                                        #     - sudo restart myservice
                                        #   - repo: git@github.com:my/repo2.git
                                        #     dest: /some/another/path
                                        #     version: master
                                        #     handlers:
                                        #     - cd /some/another/path && make static db
                                        #     - sudo /etc/init.d/service restart

source_sources_type: git              # Set repository type (git, hg)
source_copy_keys: []                  # Copy defined key files from host to server in ~/.ssh/*
source_ssh_keys: []                   # Copy keys from variables
                                      #   source_ssh_keys:
                                      #   - file_name: deploy
                                      #     private_key: "KEY CONTENT"
source_user: "{{ansible_ssh_user}}"   # Run from user
source_group: "{{source_user}}"       # Run from user
source_user_ssh_home: ~{{source_user}}/.ssh

# Repository defaults (could be replaced individually)
source_default_dest: ""               # Default destination
source_default_force: yes             # Default force
source_default_accept_hostkey: yes    # Accept hostkey (git)
source_default_bare: no               # Clone bare by default (git)
source_default_key_file: ""           # Default key file (git)
source_default_recursive: yes         # Clone recursivly by default (git)
source_default_remote: origin         # Default remote name (git)
source_default_ssh_opts:              # Default ssh options (git)
source_default_version: HEAD          # Default version (branch, tag, commit) (git)
source_default_revision: default      # Default revision (branch, tag, commit) (hg)
source_default_purge: no              # Default purge (hg)

source_fingerprints:
- "bitbucket.org,131.103.20.167 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw=="
- "github.com,204.232.175.90 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
```

#### Usage

Add `source` to your roles and set vars in your playbook file.

Example:

```yaml

- hosts: all

  roles:
    - source

  vars:
    source_copy_keys:
     - "{{inventory_dir}}/keys/deploy_key"
    source_sources:
    - repo: https://github.com/Dipsomaniac/dj-simple.git
      dest: /usr/lib/simple/source
      key_file: "/home/{{ansible_ssh_user}}/.ssh/deploy_key"
      version: "develop"
      handlers:
      - reload uwsgi
```

See [git-module](http://docs.ansible.com/git_module.html) and [hg-module](http://docs.ansible.com/hg_module.html) for source params.

#### License

Licensed under the MIT License. See the LICENSE file for details.

#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Stouts/source/issues)!
nginx
============

[![Build Status](http://img.shields.io/travis/Stouts/nginx.svg?style=flat-square)](https://travis-ci.org/Stouts/nginx)
[![Galaxy](http://img.shields.io/badge/galaxy-nginx-blue.svg?style=flat-square)](https://galaxy.ansible.com/list#/roles/854)

Ansible role which simple manage nginx

* Install and upgrade;
* Provide hanlers for restart and reload;
* Support simple site configurations.

#### Variables

```yaml
nginx_enabled: yes                  # The role in enabled
nginx_dir: /etc/nginx               # Nginx config directory
nginx_sites_dir: "{{nginx_dir}}/sites-enabled" # Nginx include directory
nginx_default_site: "{{nginx_sites_dir}}/default"
nginx_delete_default_site: no
nginx_user: www-data                # -------------------
nginx_worker_processes: 4           #   See nginx docs
nginx_worker_connections: 1024      # -------------------
nginx_sendfile: yes
nginx_keepalive_timeout: 65
nginx_gzip: yes
nginx_server_names_hash_bucket_size: 128
nginx_access_log: /var/log/nginx/access.log
nginx_error_log: /var/log/nginx/error.log
nginx_http_options:                 # Additional http options (each line will be added as is)
                                    # Ex: nginx_http_options:
                                    #       - auth_basic "You shall not pass!";
                                    #       - auth_basic_user_file {{nginx_auth_file}};

nginx_servers:                      # Setup servers (simplest interface, use cfg files for large configurations)
                                    # Ex: nginx_servers:
                                    #     - |
                                    #       listen 80;
                                    #       server_name localhost;
                                    #       location / { root html; index index.html; }
                                    #     - |
                                    #       listen 80;
                                    #       server_name test.com;
                                    #       location / { root /test; index index.html; }

nginx_auth_file: "{{nginx_dir}}/.htpasswd" # Where stored passwords
nginx_auth_users: []                # Setup users for http authentication
                                    # nginx_auth_users:
                                    #   - { name: team, password: secret }

nginx_status: 127.0.0.1             # Report about nginx state by IP. Set empty for disable.
nginx_apt_use_ppa_repo: yes         # Use of nginx PPA repo
```

#### Usage

Add `nginx` to your roles and set vars in your playbook file.

Example:

```yaml

- hosts: all

  roles:
    - nginx

  vars:
    nginx_servers:
    - |
      listen 80;
      server_name google.com;
      location / { root /var/www/google; index index.html; }
```

#### License

Licensed under the MIT License. See the LICENSE file for details.

#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Stouts/nginx/issues)!

If you wish to express your appreciation for the role, you are welcome to send
a postcard to:

    Kirill Klenov
    pos. Severny 8-3
    MO, Istra, 143500
    Russia
django
=============

[![Build Status](http://img.shields.io/travis/Stouts/django.svg?style=flat-square)](https://travis-ci.org/Stouts/django)
[![Galaxy](http://img.shields.io/badge/galaxy-django-blue.svg?style=flat-square)](https://galaxy.ansible.com/list#/roles/832)

Ansible role whith setup Django projects.


#### Requirements & Dependencies

- [wsgi](https://github.com/Stouts/wsgi)


#### Variables

```yaml
---
# vim:sw=2:ft=ansible

django_enabled: yes                           # The role is enabled

django_user: "{{deploy_user|default('root')}}" # The user who run manage commands

django_manage_list:                           # List of commands which will be executed
  - collectstatic
  - syncdb
  - migrate

django_app_dir: "{{wsgi_app_dir}}"           # Path where manage.py is exists
django_etc_dir: "{{wsgi_etc_dir}}"           # Where place a configuration files
django_env_dir: "{{wsgi_virtualenv}}"        # Use virtualenv (set blank "" to disable)

# Generate local settings
django_settings_imports:
  - from .{{deploy_env|default("")}} import *
django_settings_module: main.settings.local
django_settings_dir: "{{django_app_dir}}/{{django_settings_module.split('.')[:-1]|join('/')}}"
django_settings: "{{django_settings_dir}}/{{django_settings_module.split('.')[-1]}}.py"
django_settings_additional: []                # List of strings to add Django settings
                                              # Ex. django_settings_additional:
                                              #       - DEBUG = True
                                              #       - URLCONF = 'urls'
django_settings_databases: []                 # List of databases to add Django settings
                                              # Ex. django_settings_databases:
                                              #       - default:
                                              #           NAME: test
                                              #           USER: test
                                              #           PASSWORD: test
django_settings_caches: []                    # List of cache backends to add Django settings
                                              # Ex. django_settings_caches:
                                              #       - default:
                                              #           BACKEND: django.core.cache.backends.locmem.LocMemCache
                                              #           KEY_PREFIX: my_own_prefix
```

Also see documentation for required roles bellow.


#### Usage

* Clone dependencies.
* Add `django` to your roles
* Setup the role variables in your playbook file if needed

Example:

```yaml

- hosts: all

  roles:
    - django

  vars:
    deploy_app_name: facebook
    django_manage_list:
      - syncdb
      - migrate
      - collectstatic
    django_settings_additional:
      - OPTION = "VALUE"
      - ANOTHER_OPTION = "{{ansible_var}}"
    django_settings_databases:
      - default:
          NAME: "{{deploy_app_name}}"
          USER: "{{deploy_app_name}}"
          PASSWORD: "{{deploy_app_name}}"

```

#### License

Licensed under the MIT License. See the LICENSE file for details.


#### Feedback, bug-reports, requests, ...

Are [welcome](https://github.com/Stouts/django/issues)!
