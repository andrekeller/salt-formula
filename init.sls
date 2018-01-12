salt:
  pkg.installed:
    - name: salt

/etc/salt/minion.d:
  file.directory:
    - clean: True

/etc/salt/grains:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - source: salt://salt/files/grains
    - require:
      - file: salt-minion

salt-minion:
  service.enabled:
    - name: salt-minion
    - require:
      - pkg: salt
  file.managed:
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 0644
    - source: salt://salt/files/minion
    - require:
      - file: /etc/salt/minion.d
  cmd.run:
    - name: 'salt-call --local service.restart salt-minion'
    - bg: True
    - order: last
    - onchanges:
      - file: /etc/salt/minion
      - file: /etc/salt/grains
