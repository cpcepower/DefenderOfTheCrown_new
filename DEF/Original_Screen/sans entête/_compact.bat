@echo off

setlocal

pushd "%1"

for /f "tokens=*" %%f in ('dir /b /s *.SCR') do h:\work\compactage\exomizer203\win32\exomizer.exe raw "%%f" -o "%%f".SCP

popd