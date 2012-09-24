# -*- encoding: utf-8 -*-
import sys, json, collections

# python3 -m http.server


class Bag:
    def __init__(self):
        self._pockets = collections.defaultdict(list)

    def add(self, pocket, obj):
        self._pockets[pocket].append(obj)
    
    def all(self, pocket):
        return self._pockets[pocket]
    
    def find(self, pocket, expression):
        return filter(expression, self._pockets[pocket])

    def first(self, pocket, expression):
        for obj in self._pockets[pocket]:
            if expression(obj):
                return obj
        return None


class System:
    def __init__(self, home_drive, default_password):
        self.home_drive = home_drive
        self.default_password = default_password


class Group:
    def __init__(self, name, quota, system):
        self.name = name
        self.quota = quota
        self.quota_warn = int(quota * 0.85)
        self.system = system


class User:
    def __init__(self, name, fullname, group):
        self.name = name
        self.fullname = fullname
        self.group = group
        self.system = group.system
        self.home_directory = "%s\\%s" % (self.system.home_drive, self.name)


def read_config(fp):
    cfg = json.load(fp)
    bag = Bag()
    
    home_drive, default_password = cfg['home_drive'], cfg['default_password']
    system = System(home_drive, default_password)
    bag.add('systems', system)

    for group in cfg['groups']:
        name, quota = group['name'], group['quota']
        group = Group(name, quota, system)
        bag.add('groups', group)

    for user in cfg['users']:
        name, fullname = user['name'], user['fullname']
        group = bag.first('groups', lambda g: g.name == user['group'])
        user = User(name, fullname, group)
        bag.add('users', user)

    return bag

def parse_command_line():
    options = dict(
                config_file     = None,
                output_file     = sys.stdout,
                system_template = None,
                groups_template = None,
                users_template  = None
    )

    for i, arg in enumerate(sys.argv):
        if arg == '--config':
            options['config_file'] = open(sys.argv[i+1], 'r')

        elif arg == '--outf':
            options['output_file'] = open(sys.argv[i+1], 'w')

        elif arg == '--system':
            options['system_template'] = open(sys.argv[i+1], 'r')

        elif arg == '--groups':
            options['groups_template'] = open(sys.argv[i+1], 'r')

        elif arg == '--users':
            options['users_template'] = open(sys.argv[i+1], 'r')

    return options

def generate_system(template_fp, system):
    return template_fp.read().format(system=system)

def generate_groups(template_fp, groups):
    batch = ""
    template = template_fp.read()
    for group in groups:
        batch += template.format(group=group, system=group.system)
        batch += "\n\n"
    return batch

def generate_users(template_fp, users):
    batch = ""
    template = template_fp.read()
    for user in users:
        batch += template.format(user=user, group=user.group, system=user.system)
        batch += "\n\n"
    return batch

if __name__ == '__main__':
    options = parse_command_line()
    config = read_config(options['config_file'])
    outf = options['output_file']

    if options['system_template']:
        template = options['system_template']
        system = config.first('systems', lambda s: True)
        outf.write(generate_system(template, system))

    if options['groups_template']:
        template = options['groups_template']
        groups = config.all('groups')
        outf.write(generate_groups(template, groups))

    if options['users_template']:
        template = options['users_template']
        users = config.all('users')
        outf.write(generate_users(template, users))


