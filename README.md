Solr Configuration for SAP Hybris
=========
[![License](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](https://raw.githubusercontent.com/lean-delivery/ansible-role-solr-hybris-config/master/LICENSE)
[![Build Status](https://travis-ci.org/lean-delivery/ansible-role-solr-hybris-config.svg?branch=master)](https://travis-ci.org/lean-delivery/ansible-role-solr-hybris-config)
[![Build Status](https://gitlab.com/lean-delivery/ansible-role-solr-hybris-config/badges/master/build.svg)](https://gitlab.com/lean-delivery/ansible-role-solr-hybris-config/pipelines)
[![Galaxy](https://img.shields.io/badge/galaxy-lean__delivery.solr__hybris__config-blue.svg)](https://galaxy.ansible.com/lean_delivery/solr_hybris_config)
![Ansible](https://img.shields.io/ansible/role/d/30253.svg)
![Ansible](https://img.shields.io/badge/dynamic/json.svg?label=min_ansible_version&url=https%3A%2F%2Fgalaxy.ansible.com%2Fapi%2Fv1%2Froles%2F30253%2F&query=$.min_ansible_version)
## Summary

This role:
  - Configures Solr on Centos 7, Ubuntu or Windows host to work with hybris.

Requirements
------------
  - Minimal Version of the ansible for installation: 2.7
  - **Java 8** [![Build Status](https://travis-ci.org/lean-delivery/ansible-role-java.svg?branch=master)](https://travis-ci.org/lean-delivery/ansible-role-java)
  - **Solr installed** [![Build Status](https://travis-ci.org/lean-delivery/ansible-role-solr.svg?branch=master)](https://travis-ci.org/lean-delivery/ansible-role-solr)
  - **Supported OS**:
    - CentOS
      - 7
    - Ubuntu
    - Debian
      - 9
    - Windows
      - "Windows Server 2008"
      - "Windows Server 2008 R2"
      - "Windows Server 2012"
      - "Windows Server 2012 R2"
      - "Windows Server 2016"
      - "Windows Server 2019"
      - "Windows 7"
      - "Windows 8.1"
      - "Windows 10"

[Prepared Windows System](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)

## Role Variables
  - `solr_version` - matches available version on https://archive.apache.org/dist/lucene/solr/. Tested versions 5.3-7.5.x

    default: `7.5.0`

  - `solr_contrib_hybris_patch_name` - Hybris patch name (stored in files and prepared by sh scripts in files dir)

    default: `solr-contrib-HYBRISCOMM180800P_1-70003534.zip`

  - `solr_data_hybris_patch_name` - Hybris patch name (stored in files and prepared by sh scripts in files dir)

    default: `solr-data-HYBRISCOMM180800P_1-70003534.zip`

  - `solr_patch_transport` - solr patch source transport

    default: `local`

    Available:

     - `web` - fetch patch from custom web uri

     - `local` - local patch

     - `s3` - fetch patch from s3 bucket

  - `solr_patch_transport_web` - URI for http/https patch

    default: `http://my-storage.example.com`

  - `solr_patch_transport_local` - path for local patch directory

    default: `/tmp`

  - `solr_patch_transport_s3_bucket` - s3 bucket name

    default: `s3_bucket`

  - `solr_patch_transport_s3_path` - path to patch folder in bucket

    default: `/folder`

  - `transport_s3_aws_access_key` - aws key. Need to set in role or set as parameter or set env variables according https://docs.ansible.com/ansible/latest/modules/aws_s3_module.html

    default: `undefined`

  - `transport_s3_aws_secret_key` - aws secret key. Need to set in role or set as parameter or set env variables according https://docs.ansible.com/ansible/latest/modules/aws_s3_module.html

    default: `undefined`

  - `download_path` - local folder for downloading patch

    default: `/tmp` for Linux OS

    default: `C:\Solr` for Windows OS

  - `solr_dest_main_path` - root directory to store solr folder

    default: `/opt` for Linux

    default: `C:\Solr` for Windows

  - `solr_dest_path` - solr folder path

    default: `{{ dest_main_path }}/solr-{{ solr_version }}`

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

  - `solr_service_start` - to start solr service in the end of role/Playbook

    default: `True`

## Maven Role Variables  
  -  `solr_maven_libs_configure` - install additional solr libraries from a Maven repository  
  
    default: `False`  
  
  -  `solr_maven_libs_classifier_configure` - install additional solr libraries with classifier from a Maven repository  
  
    default: `False`  
  
  -  `solr_maven_libs_version` - the version of Maven artifact  
  
    default: `2.1.1`  
  
  -  `solr_maven_group_id:` - the Maven group ID
  
    default: `org.lionsoul`  
  
  -  `solr_maven_repository_url` - the URL of the Maven Repository to download from  
  
    default: `https://repo1.maven.org/maven2`  
  
  -  `solr_maven_classifier` - the Maven classifier (see note about classifier below)  
  
    default: `javadoc` 
    
  -  `solr_maven_libs_list` - the list of Maven artifacts  
  
    default: 
    ```
      - jcseg-analyzer
      - jcseg-core
      - jcseg-elasticsearch 
      - jcseg-server
    ```  
  
  -  `solr_maven_libs_dest` - path on the local filesystem for downloaded Maven artifacts  
  
    default: `{{ solr_dest_path }}/server/solr-webapp/webapp/WEB-INF/lib`

### Note about Classifier
----------------
```
The classifier distinguishes artifacts that were built from the same POM but differ in content.
It is some optional and arbitrary string that - if present - is appended to the artifact name just after the version number.
```

## Patch Creation
----------------
Bash script files/create-solr-extras.sh can be used to create patch file.
Run with following parameters:
  `-a` - folder or web source with hybris archive. Patches will be stored here too

  Default is /opt/installs

  `-p` - Hybris package name

  Default is HYBRISCOMM180800P_0-70003534

  `-e` - Hybris package extension

  Default is ZIP

  `-c` - Contrib patch file name

  Default is solr-contrib-$package

  `-d` - Elasticsearch index name

  Default is solr-data-$package

After patch creation please upload it to destination and set transport parameters.

Example Inventory
----------------
```ini
[solr]
solr.example.com

[solrwin]
solrwin.example.com

[solrwin:vars]
ansible_user=admin
ansible_password=password
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
```

Example Playbook
----------------

```yml
- name: Configure Solr for SAP Hybris
  hosts: solr
  roles:
    - role: lean_delivery.java
    - role: lean_delivery.solr_standalone
    - role: lean_delivery.solr_hybris_config
```

Example Playbook with Maven enabled
----------------  
  
```yml  
- name: Configure Solr for SAP Hybris with additional solr libraries form Maven 
hosts: solr  
roles:  
- role: lean_delivery.java  
- role: lean_delivery.solr_standalone  
- role: lean_delivery.solr_hybris_config
  solr_maven_libs_configure:  true  
  solr_maven_libs_classifier_configure:  true  
  solr_maven_libs_version: 2.1.1  
  solr_maven_group_id: 'org.lionsoul'  
  solr_maven_repository_url: 'https://repo1.maven.org/maven2'  
  solr_maven_classifier: 'javadoc'  
  solr_maven_libs_list:  
    - 'jcseg-analyzer'  
    - 'jcseg-core'  
    - 'jcseg-elasticsearch'  
    - 'jcseg-server'  
  solr_maven_libs_dest: '{{ solr_dest_path }}/server/solr-webapp/webapp/WEB-INF/lib'  
```

License
-------

Apache

Author Information
------------------

authors:
  - Lean Delivery Team <team@lean-delivery.com>
