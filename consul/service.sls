# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import consul with context %}

consul_init_file:
  file.managed:
    {% if salt['test.provider']('service') == 'systemd' %}
    - source: salt://{{ slspath }}/files/consul.service
    - name: /etc/systemd/system/consul.service
    - mode: 0444
    {% elif salt['test.provider']('service') == 'upstart' %}
    - source: salt://{{ slspath }}/files/consul.upstart
    - name: /etc/init/consul.conf
    - mode: 0444
    {% else %}
    - source: salt://{{ slspath }}/files/consul.sysvinit
    - name: /etc/init.d/consul
    - mode: 0555
    {% endif %}

{% if consul.service %}
consul_service:
  service.running:
    - name: consul
    - enable: True
    - watch:
      - file: consul-init-file
{% endif %}
