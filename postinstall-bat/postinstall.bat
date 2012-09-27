robocopy "%SystemDrive%\Users" "D:\" /mir /xj /copyall
rmdir "%SystemDrive%\Users" /s /q
mklink /j "%SystemDrive%\Users" "D:\"

set dir1="%SystemDrive%\Documents and Settings"
rmdir "%dir1%"
mklink /j "%dir1%" "D:\"

set dir2="%SystemDrive%\ProgramData\Desktop"
rmdir "%dir2%"
mklink /j "%dirr2%" "D:\Public\Desktop"

set dir3="%SystemDrive%\ProgramData\Documents"
rmdir "%dir3%"
mklink /j "%dirr3%" "D:\Public\Documents"

set dir4="%SystemDrive%\ProgramData\Favorites"
rmdir "%dir4%"
mklink /j "%dirr4%" "D:\Public\Favorites"

