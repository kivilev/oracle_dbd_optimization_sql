@echo off
set app = tkprof.exe
for %%f in (*.trc) do (   
  if not exist "%%~f.txt" (
    echo Creation %%f...
    tkprof "%%~f" "%%~f.txt" sort=prsela,fchela,exeela sys=no
  )  
)
