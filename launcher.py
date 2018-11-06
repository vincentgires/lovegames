#!/usr/bin/env python

import os
import subprocess
import sys

currentpath = os.path.dirname(__file__)
gamepath = os.path.join(currentpath, 'superpolygon')
if sys.platform.startswith('win'):
    love = 'love.exe'
else:
    love = 'love'
command = [love, gamepath]
subprocess.call(command)
