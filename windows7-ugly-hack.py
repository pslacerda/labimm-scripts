#!/usr/bin/python2.7
# -*- encoding: utf-8 -*-

#
# usage:
#   $ python windows7-ugly-hack.py
#

#############################################
#        SETUP
#############################################

class system:
    home_drive       = 'D:'
    default_password = 'labimm123'

groups = [
    ('doutorado', 15, (
        ('andré', 'André Vina'),
        ('humbarato', 'Humberto Barato'))),

    ('mestrado', 10, (
        ('camila', 'Camila UNKNOW'),)),

    ('iniciação', 5, (
        ('kanvuanza', 'Pedro Lacerda'),))
]


##########################################
#      TEMPLATES
##########################################

SYSTEM_TEMPLATE = """
:-------------------:
:   System config   :
:-------------------:
fsutil quota enforce {system.home_drive}

"""

GROUP_TEMPLATE = """
:---------------:
:   New group   :
:---------------:
net localgroup {group.name} /add

"""

USER_TEMPLATE = """
:--------------:
:   New user   :
:--------------:

: create user
net user {user.name} {system.default_password} ^
 /add                             ^
 /fullname:"{user.fullname}"     ^
 /logonpasswordchg:yes

: create disk quota
fsutil quota modify {system.home_drive} {group.warn} {group.quota} {user.name}

: move home directory to another drive
md {user.home}
robocopy /mir /xj C:\\Users\\{user.name} {system.home_drive}\\{user.name}"
rmdir /s /q C:\\Users\\{user.name}
mklink /j C:\\Users\\{user.name} {system.home_drive}\\{user.name}

: restrict permissions
: TODO

"""


##############################################
#        CODE GENERATION
#############################################

class AttributeDict (dict):
    __getattr__ = dict.__getitem__
    __setattr__ = dict.__setitem__


class User (AttributeDict):
    def __init__(self, name, fullname):
        self.name = name
        self.fullname = fullname
        self.home = "%s\\%s" % (system.home_drive, self.name)


class Group (AttributeDict):
    def __init__(self, name, quota, members):
        self.name = name
        self.quota = quota * 1024**3
        self.warn = int(self.quota * 0.85)
        self.members = members


def build_objects(people):
    groups = []
    for gname, gquota, gmembers in people:
        users = []
        for uname, ufullname in gmembers:
            users.append(User(uname, ufullname))
        groups.append(Group(gname, gquota, users))
    return groups

def format_system(system):
    return SYSTEM_TEMPLATE.format(**locals())

def format_group(group, system):
    return GROUP_TEMPLATE.format(**locals())

def format_user(user, group, system):
    return USER_TEMPLATE.format(**locals())


################################################
#        COMMAND LINE APP
###############################################

if __name__ == '__main__':
    
    groups = build_objects(groups)
    batch = format_system(system)

    for group in groups:
        batch += format_group(group, system)
        for user in group.members:
            batch += format_user(user, group, system)
    print batch

