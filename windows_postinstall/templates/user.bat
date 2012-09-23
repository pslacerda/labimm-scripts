
::
:: User setup
::

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

