:: create user
net user {user.name} {system.default_password} /add /fullname:"{user.fullname}" /logonpasswordchg:yes

:: create disk quota
fsutil quota modify {system.home_drive} {group.quota_warn} {group.quota} {user.name}

:: move home directory to home drive
md {user.home_directory}
robocopy /mir /xj {user.home_directory} {system.home_drive}\{user.name}
rmdir /s /q C:\Users\{user.name}
mklink /j C:\Users\{user.name} {user.home_directory}

:: restrict permissions
:: TODO

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

