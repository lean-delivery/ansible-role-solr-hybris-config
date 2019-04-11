Solr Configuration for SAP Hybris
=========
[![License](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](https://raw.githubusercontent.com/lean-delivery/ansible-role-solr-hybris-config/master/LICENSE)
[![Build Status](https://travis-ci.org/lean-delivery/ansible-role-solr-hybris-config.svg?branch=master)](https://travis-ci.org/lean-delivery/ansible-role-solr-hybris-config)
[![Build Status](https://gitlab.com/lean-delivery/ansible-role-solr-hybris-config/badges/master/build.svg)](https://gitlab.com/lean-delivery/ansible-role-solr-hybris-config)
[![Galaxy](https://img.shields.io/badge/galaxy-lean__delivery.solr-hybris-config-blue.svg)](https://galaxy.ansible.com/lean_delivery/solr-hybris-config)
![Ansible](https://img.shields.io/ansible/role/d/30253.svg)
![Ansible](https://img.shields.io/badge/dynamic/json.svg?label=min_ansible_version&url=https%3A%2F%2Fgalaxy.ansible.com%2Fapi%2Fv1%2Froles%2F30253%2F&query=$.min_ansible_version)
## Summary

This role:
  - Configures Solr on Centos 7, Ubuntu or Windows host to work with hybris.

Requirements
------------
  - Minimal Version of the ansible for installation: 2.5
  - **Java 8** [![Build Status](https://travis-ci.org/lean-delivery/ansible-role-java.svg?branch=master)](https://travis-ci.org/lean-delivery/ansible-role-java)
  - **Solr installed** [![Build Status](https://travis-ci.org/lean-delivery/ansible-role-solr.svg?branch=master)](https://travis-ci.org/lean-delivery/ansible-role-solr)
  - **Supported OS**:
    - CentOS
      - 7
    - Ubuntu
    - Windows
      - "Windows Server 2008"
      - "Windows Server 2008 R2"
      - "Windows Server 2012"
      - "Windows Server 2012 R2"
      - "Windows Server 2016"
      - "Windows 7"
      - "Windows 8.1"
      - "Windows 10"

[Prepared Windows System](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)

## Role Variables
  - `solr_version` - matches available version on https://archive.apache.org/dist/lucene/solr/. Tested versions 5.3-7.1.x
    default: `7.1.0`
  - `solr_contrib_hybris_patch_name` - Hybris patch name (stored in files and prepared by sh scripts in files dir)
    default: `solr-contrib-HYBRISCOMM6600P_0-70003031.zip`
  - `solr_data_hybris_patch_name` - Hybris patch name (stored in files and prepared by sh scripts in files dir)
    default: `solr-data-HYBRISCOMM6600P_0-70003031.zip`
  - `transport` - solr patch source transport
    default: `local`
    Available:
     - `web` - fetch patch from custom web uri
     - `local` - local patch
     - `s3` - fetch patch from s3 bucket
  - `transport_web` - URI for http/https patch
    default: `http://my-storage.example.com`
  - `transport_local` - path for local patch directory
    default: `/tmp`
  - `transport_s3_bucket` - s3 bucket name
    default: `s3_bucket`
  - `transport_s3_path` - path to patch folder in bucket
    default: `/folder`
  - `transport_s3_aws_access_key` - aws key. Need to set in role or set as parameter or set env variables according https://docs.ansible.com/ansible/latest/modules/aws_s3_module.html
    default: `undefined`
  - `transport_s3_aws_secret_key` - aws secret key. Need to set in role or set as parameter or set env variables according https://docs.ansible.com/ansible/latest/modules/aws_s3_module.html
    default: `undefined`
  - `download_path` - local folder for downloading patch
    default: `/tmp`
  - `solr_dest_main_path` - root directory to store solr folder
    default: `/opt`
    default: `C:\Solr`
  - `solr_dest_path` - solr folder path
    default: `{{ dest_main_path }}/solr-{{ solr_version }}`
    default: `{{ dest_main_path }}\solr-{{ solr_version }}`
  - `solr_user` - os user to run solr service
    default: `solr`
  - `solr_group` - os group for user
    default: `solr`
  - `solr_service_name` - solr service name
    default: `solr`
  - `solr_base_path` - path to solr base
    default: `/var/solr`
  - `solr_home` - path to SOLR_HOME
    default: `{{ solr_base_path }}/data`
  - `solr_with_systemd` - to run solr as a service
    default: `True`

Patch Creation
----------------
Bash script files/create-solr-extras.sh can be used to create patch file.
Change following varibles in file before run:
  - `artifactory` - http or local path to hybris package
  - `package` - hybris package name
  - `zip_extension` - package extension
  - `zip_file` - output file name
After patch creation please upload it to destination and set transport parameters.

Example Inventory
----------------
[solr]
solr.example.com

[solrwin]
solrwin.example.com

[solrwin:vars]
ansible_user=admin
ansible_password=password
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore

Example Playbook
----------------

```yml
- name: Configure Solr for SAP Hybris
  hosts: solr
  roles:
    - role: lean-delivery.java
    - role: lean-delivery.solr_standalone
    - role: lean-delivery.solr_hybris_config
```

License
-------

Apache

Author Information
------------------

authors:
  - Lean Delivery Team <team@lean-delivery.com>
