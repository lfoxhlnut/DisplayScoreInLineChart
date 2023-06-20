$to_del = 'bin', 'interface.build', 'interface.dist'
foreach ($folder in $to_del)
{
    if (test-path -path $folder)
    {
        remove-item $folder -force
    }
}


$win_icon_file_path = '..\Resource\Icon\icon.ico'

nuitka --mingw64 --standalone `
    --follow-imports `
    --nofollow-import-to=numpy,jinja2,matplotlib,scipy,sqlalchemy,pandas,pygal,pyzbar `
    --warn-implicit-exceptions --warn-unusual-code --assume-yes-for-downloads `
    --enable-plugin=pylint-warnings `
    --windows-icon-from-ico=$win_icon_file_path `
    --remove-output `
    .\interface.py

rename-item -path interface.dist -newname bin