import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'


def test_systemd(host):
    s = host.service("solr")

    assert s.is_running
    assert s.is_enabled


def test_solr_file(host):
    avars = host.ansible.get_variables()
    f1 = host.file("/".join(avars["solr_dest_path"], "contrib/hybris"))
    f2 = host.file("/".join(avars["solr_home"], "configsets/default"))

    assert f1.exists
    assert f2.exists
