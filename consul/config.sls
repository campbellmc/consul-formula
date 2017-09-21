# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import consul with context %}

consul_config_json:
  file.managed:
    - name: /etc/consul.d/config.json
    {% if consul.service != False %}
{#    - watch_in: #}
{#       - service: consul #}
    {% endif %}
    - user: consul
    - group: consul
    - require:
      - user: consul
    - contents: |
        {{ consul.config | json }}
