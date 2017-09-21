# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import consul with context %}

consul_dep_unzip:
  pkg.installed:
    - skip_suggestions: True
    - refresh: False
    - pkgs:
      - unzip

consul_bin_dir:
  file.directory:
    - name: /usr/local/bin
    - makedirs: True

# Create consul user
consul_user:
  group.present:
    - name: consul
    - system: True
  user.present:
    - name: consul
    - createhome: false
    - system: true
    - gid_from_name: True
    - groups:
      - consul
    - require:
      - group: consul

# Create directories
consul_config_dir:
  file.directory:
    - name: /etc/consul.d
    - user: consul
    - group: consul

consul_data_dir:
  file.directory:
    - name: {{ consul.config.data_dir }}
    - user: consul
    - group: consul
    - makedirs: True

# Install agent
consul_download:
  file.managed:
    - name: /tmp/consul_{{ consul.version }}_linux_{{ consul.arch }}.zip
    - source: https://{{ consul.download_host }}/consul/{{ consul.version }}/consul_{{ consul.version }}_linux_{{ consul.arch }}.zip
    - source_hash: https://releases.hashicorp.com/consul/{{ consul.version }}/consul_{{ consul.version }}_SHA256SUMS
    - unless: test -f /usr/local/bin/consul-{{ consul.version }}

consul_extract:
  cmd.wait:
    - name: unzip /tmp/consul_{{ consul.version }}_linux_{{ consul.arch }}.zip -d /tmp
    - watch:
      - file: consul_download

consul_install:
  file.rename:
    - name: /usr/local/bin/consul-{{ consul.version }}
    - source: /tmp/consul
    - require:
      - file: /usr/local/bin
    - watch:
      - cmd: consul_extract

consul_clean:
  file.absent:
    - name: /tmp/consul_{{ consul.version }}_linux_{{ consul.arch }}.zip
    - watch:
      - file: consul_install

consul_link:
  file.symlink:
    - target: consul-{{ consul.version }}
    - name: /usr/local/bin/consul
    - watch:
      - file: consul_install
