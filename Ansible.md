# What is Ansible?

Ansible is an automation and configuration-management tool.

We use it to automate tasks across multiple servers, such as:

Installing packages
Starting/stopping services
Copying files
Changing configurations
Creating users
Deploying applications

For example, if you have 20 Linux servers and need to install Nginx on all of them, instead of connecting to each server manually, Ansible can automate the task.

```
                 Ansible
                Controller
                    |
          ---------------------
          |         |         |
       Server 1  Server 2  Server 3
```

Ansible is agentless.

That means we normally do not install an Ansible agent on the managed Linux servers.

For Linux, Ansible commonly connects using SSH.

```
Ansible Controller
       |
       | SSH
       ↓
Managed Linux Server
```

# Controller Node vs Managed Node

### 1. Controller Node

The Controller Node is the machine from which you run Ansible.

For example:

```
Your Linux/EC2 machine
        ↓
Ansible installed here
        ↓
You run Ansible commands
```

It contains things like:

Ansible
Inventory
Playbooks
Configuration
SSH keys/credentials

### 2. Managed Node

Managed Nodes are the target servers that Ansible configures or manages

```
                Controller
              10.0.1.10
                   |
             SSH connection
          _____ ___|_____
         ↓     ↓         ↓
      Web-1  Web-2     DB-1
```

# Inventory

An inventory is a file that contains information about the servers managed by Ansible.

```
[webservers]
web1 ansible_host=10.0.1.20
web2 ansible_host=10.0.1.21

[dbservers]
db1 ansible_host=10.0.1.30
```

# How Ansible Connects to Linux Servers

The Controller's public key should be present in the Managed Node's ~/.ssh/authorized_keys file, and the Controller keeps the corresponding private key.

```
Controller                         Managed Node
   |                                    |
   | Private key                         |
   |-------------------- SSH ---------->|
   |                                    |
   |                         authorized_keys
   |                         contains matching
   |                         public key
   |                                    |
   |<--------- Authentication ---------->|
```

# Start Lab

## Install Ansible

```
sudo apt update
sudo apt install ansible-core -y
ansible --version
```

```
nano inventory

[webservers]

web1 ansible_host=172.31.0.240

```
```
ansible -i inventory webservers -m ping
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
Command:- ansible -i inventory webservers -m command -a "df -h"
Shell:- ansible -i inventory webservers -m shell -a "df -h | grep /boot"
Script:- ansible -i inventory webservers -m script -a "test.sh"
Copy:- ansible -i inventory webservers -m copy -a "src=test.txt dest=/tmp/test.txt"
File:- ansible -i inventory webservers -m file -a "path=/tmp/mydir state=directory" state=touch
Apt:- ansible -i inventory webservers -m apt -a "name=nginx state=present" --become
Service:- ansible -i inventory webservers -m service -a "name=nginx state=started" --become
User:- ansible -i inventory webservers -m user -a "name=devuser state=present" --become
Group: ansible -i inventory webservers -m group -a "name=developers state=present" --become
```

# Ad-hoc Command

An ad-hoc command is a single Ansible command used to perform one task immediately, without creating a playbook.

```
ansible -i inventory webservers -m command -a "uptime"
```

# Ansible Playbook

Ansible Playbook is a YAML file where we define the tasks that Ansible should perform on managed servers.

```
---
- name: Install tree
  hosts: webservers
  become: true
  tasks:
   - name: Install tree
     apt:
      name: tree
      state: present

   - name: Create a directory
     file:
      path: /tmp/ansible-demo
      state: directory

```

```
ansible-playbook -i inventory playbook.yml
```

# Ansible Variables

A variable is simply a name that stores a value.

```
---
- name: Install tree
  hosts: webservers
  become: true
  vars:
   package_name: tree
  tasks:
   - name: Install tree
     apt:
      name: "{{ package_name }}"
      state: present
```

# debug  

debug is an Ansible module used to display information/output while the playbook is running.

msg means message — what you want Ansible to display.

```
---
- name: Install htop
  hosts: webservers
  become: true
  vars:
   package_name: htop
   directory_path: /tmp/learn-demo


  tasks:
   - name: Install tree
     apt:
      name: "{{ package_name }}"
      state: present


   - name: Create a directory
     file:
      path: "{{ directory_path }}"
      state: directory

   - name: Show package name
     debug:
      msg: "{{ package_name }}"


```

# when

In Ansible, when is used to run a task only when a condition is true.

```
---
- name: Install docker
  hosts: webservers
  become: true
  vars:
   package_name: htop
  


  tasks:
   - name: Install docker
     apt:
      name: "{{ package_name }}"
      state: present
     when:
      - ansible_facts['distribution'] == "CentOS"
      - package_name == "docker.io"

```

# loop

loop is used to repeat the same task for multiple items.

```

---
 - name: Install package
   hosts: webservers
   become: true

   tasks:

    - name: Install package
      apt:
       name: "{{ item }}"
       state: present
      loop:
        - git
        - curl
```

# Handler

A special Ansible task that runs only when another task makes a change.
notify tells Ansible which Handler should run when the task changes.	


```
---
- name: Configure nginx
  hosts: webservers
  become: true

  tasks:

    - name: Copy nginx configuration
      copy:
        src: nginx.conf
        dest: /etc/nginx/nginx.conf
      notify: Restart nginx

  handlers:

    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

# # Fact:-

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

# Jinja Template

A template is used when we want to create the same type of configuration on many servers, but some values need to be different for each server.

Example:-

Suppose you have 100 servers and you want to create an application configuration on all of them.
Most of the configuration is the same, but the application port is different:
Instead of creating 100 different configuration files, we create one template and use variables for the values that change.
Ansible uses that one template and creates the appropriate configuration on each server.

### Inventory

[servers]
s1 ansible_host=1.1.1.1 app_port=8080
s2 ansible_host=2.2.2.2 app_port=8081

### app.conf.j2

APP_NAME=ShopSphere
DB_HOST=10.0.0.50
DB_NAME=shopdb
PORT={{ app_port }}
LOG_LEVEL=INFO

### Playbook

---
- name: Create application config
  hosts: servers

  tasks:
    - name: Create config file
      template:
        src: app.conf.j2
        dest: /tmp/app.conf



# Ansible Role:

Ansible Roles are used to organize playbooks and related files into a structured, reusable directory structure.

The six components are:

myapp/
├── tasks/
│   └── main.yml
├── handlers/
│   └── main.yml
├── templates/
├── files/
├── vars/
│   └── main.yml
└── defaults/
    └── main.yml


taks/main.yml

- name: Install nginx
  apt:
    name: nginx
    state: present

playbook.yml

- name: Configure application
  hosts: servers
  roles:
    - myapp

To create a role:- ansible-galaxy role init myapp

ansible-playbook -i inventory playbook.yml


# import_role vs include_role

import_role is static and processed at parse time, whereas include_role is dynamic and processed at runtime.

- name: Install Nginx
  apt:
    name: nginx
    state: present

- name: Run application role
  import_role:
    name: myapp

- name: Install Docker
  apt:
    name: docker.io
    state: present



# Ansible Vault

Ansible Vault is a feature in Ansible used to encrypt sensitive information such as passwords, API keys, and credentials so that secrets are not stored in plain text.

ansible-vault create secrets.yml

ansible-vault edit secrets.yml

ansible-vault view secrets.yml

ansible-vault decrypt secrets.yml


- hosts: servers
  vars_files:
    - secrets.yml

  tasks:
    - name: Show password
      debug:
        msg: "{{ db_password }}"

ansible-playbook -i inventory playbook.yml --ask-vault-pass


				
