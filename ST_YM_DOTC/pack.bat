
@echo off

setlocal

pushd "%1"

for /f "tokens=*" %%f in ('dir /b /s *.R*') do ("h:\work\compactage\PackFire.exe" -t "%%f" -b "%%f".pck
echo "%%f")

popd

