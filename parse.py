# This small script will parse the contents of the setup.py and vtk.py scripts before building wheels
from re import sub, DOTALL
with open('setup.py', 'r') as file:
    contents = sub("name[ ]*=[ ]*['\"]vtk['\"]", "name='vtk_tk'", file.read(), DOTALL)
with open('setup.py', 'w') as file:
    file.write(contents)

with open('vtk.py', 'a') as file:
    file.write(
        "from os.path import dirname, join\n"
        "import sys\n"
        "sys.path.append(join(dirname(__file__), 'vtkmodules'))\n"
    )
