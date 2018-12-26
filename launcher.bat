@echo off
set PATH=%~dp0\love
set LUA_PATH=%~dp0\lib\?.lua;%~dp0\lib\?\init.lua
start love.exe %1
