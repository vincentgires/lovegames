#!/usr/bin/env python

import os
import subprocess

currentpath = os.path.dirname(__file__)
gamepath = os.path.join(currentpath, 'superpolygon')
love = 'love'
command = [love, gamepath]
subprocess.call(command)
