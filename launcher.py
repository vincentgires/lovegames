#!/usr/bin/env python

import os
import subprocess
import sys

currentpath = os.path.dirname(__file__)
gamepath = os.path.join(currentpath, sys.argv[-1])
libpath = os.path.join(currentpath, 'lib')

if sys.platform.startswith('win'):
    love = 'love.exe'
else:
    love = 'love'

env = os.environ.copy()
env_filepath = os.path.join(libpath, '?.lua')
env_dirpath = os.path.join(libpath, '?', 'init.lua')

if 'LUA_PATH' not in env:
    env['LUA_PATH'] = f'{env_filepath};{env_dirpath}'
else:
    env['LUA_PATH'] += f';{env_filepath};{env_dirpath}'

command = [love, gamepath]
subprocess.call(command, env=env)
