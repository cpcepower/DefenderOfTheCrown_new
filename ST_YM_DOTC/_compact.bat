@echo off

setlocal

pushd "%1"

for /f "tokens=*" %%f in ('dir /b /s *.AYC') do h:\work\compactage\exomizer203\win32\exomizer.exe raw "%%f" -o "%%f".SPC

popd