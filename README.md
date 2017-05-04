## ansible-icinga2-client
Ansible playbook to configure a host client with services for Icinga2

## Dependencies
- python requests
- python-httplib2

## Tests
Tested with: 
- ansible 2.3.0.0
- Python 2.7.12

## Use 
*Must have login with keys setup*
Run with ansible-playbook icinga2-client.yml --private-key=\<ident-file\> -u \<conection-user\> -i \<target-host-ip\>,

Configure desired environment in vars/icinga-vars.yml and vars/services.yml
Read the readmes at scripts/ and vars/ for more information
