# What is Ansible?

Ansible is an automation and configuration management tool used to automate tasks such as:

Server configuration
Package installation
Service management
User creation
Application deployment
Configuration changes

Ansible is agentless and typically uses SSH to communicate with Linux managed nodes.

# Ansible Architecture

Ansible mainly has two sides:

Control Node and Managed Nodes

The Control Node is where Ansible is installed and where we execute commands or playbooks. Managed Nodes are the target servers that Ansible configures or manages. Ansible is agentless and typically communicates with Linux servers using SSH.

# Agentless + SSH

Ansible is agentless, which means we normally don't need to install an Ansible agent on the managed Linux servers. The Control Node connects to the managed nodes using SSH and executes the required tasks or modules remotely.

# Inventory

Ansible Inventory is a list of servers or groups on which we can execute Ansible commands.

```
[webservers]
web01 ansible_host=192.168.1.10
web02 ansible_host=192.168.1.11

[dbservers]
db01 ansible_host=192.168.1.20
```

# Inventory Hands-on

## Install Ansible

```
sudo apt update
sudo apt install ansible-core -y
ansible --version
```

## Create inventory file

```
mkdir -p ~/ansible
cd ~/ansible
nano inventory

[webservers]
server1 ansible_host=172.31.0.240 ansible_user=ubuntu
```
```
ansible -i webservers -m ping
```

# Ad-hoc Commands

Ad-hoc command is used to perform a quick, one-time task on one or more managed servers without creating a playbook.

```
ansible -i inventory webservers -m command -a "uptime"
```

# Ansible Modules.

A module is the Ansible tool that performs a specific task on managed nodes.

ping, command, shell, apt, service, copy and so on
```
ping → connectivity check
command → simple Linux command
shell → shell features ke saath command
apt → package management
service → service management
copy → file copy
file → file/directory create/delete/permissions
```
## command vs shell Module

The command module runs commands directly without using the shell. The shell module runs commands through the shell and supports shell features like pipes and redirection. I prefer the command module when shell features are not required.

```
ansible -i inventory webservers -m command -a "df -h"
ansible -i inventory webservers -m shell -a "df -h | grep /boot"
```

# Playbook

An Ansible Playbook is a YAML file where we define the tasks that Ansible should perform on managed servers.

```
playbook.yml
---
- name: My First Playbook
  hosts: webservers
  tasks:
    - name: Check hostname
      command: hostname
    - name: Check uptime and Disk status
      shell: "uptime && df -h"
```

```
ansible-playbook -i inventory playbook.yml
```

```
# Variable

---
- name: My First Playbook
  hosts: webservers
  become: yes
  vars:
     package_name: nginx
  tasks:
    - name: Check hostname
      command: hostname
      register: result
    - name: Show hostname
      debug:
        var: result
    - name: Install package
      apt:
        name: "{{ package_name }}"
        state: present
        update_cache: yes

```

# Fact:-

automatically collected information about the managed node.

```
---
- name: Check Server Facts
  hosts: webservers
  tasks:
    - name: Show all facts
      debug:
        var: ansible_facts
```

# When:- 

is used for conditional task execution in Ansible. If the condition evaluates to true, the task runs; otherwise, Ansible skips the task.

```
---
- name: Check Server Facts
  hosts: webservers
  tasks:
    - name: Show all info
      debug:
        var: ansible_facts.distribution
    - name: Create test file on Ubuntu
      file:
        path: /tmp/ansible-test
        state: touch
      when: ansible_facts.distribution == "Ubuntu"
```

# Loop: 

A loop is used when we need to perform the same task for multiple items, instead of writing the same task repeatedly.

```
---
- name: Loop Example
  hosts: webservers

  tasks:
    - name: Create test files
      file:
        path: "/tmp/{{ item }}"
        state: touch
      loop:
        - file1
        - file2
        - file3
```

```
---
- name: Install Multiple Packages
  hosts: webservers
  become: yes

  tasks:
    - name: Install packages
      apt:
        name: "{{ item }}"
        state: present
        update_cache: yes
      loop:
        - nginx
        - git
        - curl
```


# Templates (Jinja2): 

Jinja2 is used in Ansible to create template files where we can insert variable values dynamically.

For example, we can use {{ server_name }} in a template, and Ansible will replace it with the actual server name while creating the configuration file.
