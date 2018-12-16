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
env_path = os.path.join(libpath, '?.lua')
if 'LUA_PATH' in env:
    env['LUA_PATH'] += ';{}'.format(env_path)
else:
    env['LUA_PATH'] = env_path

command = [love, gamepath]
subprocess.call(command, env=env)
