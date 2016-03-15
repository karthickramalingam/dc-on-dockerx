FROM openswitch/genericx86-64

MAINTAINER Kei Nohguchi <kei@nohguchi.com>

# Copy the ssh public key
RUN mkdir /home/admin/.ssh
COPY id_rsa.pub /home/admin/.ssh/authorized_keys
RUN chown -R admin:ops_admin /home/admin/.ssh
RUN chmod 0700 /home/admin/.ssh
RUN chmod 0400 /home/admin/.ssh/authorized_keys

# Ports to be exposed to the Ansible control machine
EXPOSE 22
