# -*- coding: utf-8 -*-
# vim: ft=sls

{% from slspath+"/map.jinja" import consul with context %}

include:
  - {{ slspath }}.install
  - {{ slspath }}.config
  - {{ slspath }}.service
