This project aims to compile VTK with Python bindings and the tkinter gui library for ubuntu 18.04

The script getvtk.sh can be used to generate a docker image in which VTK is compilled automatically
and a python wheel is generated.

Instead of building the docker image manually, you can pull it from the github registry with:

```bash
docker pull docker.pkg.github.com/vykstorm/vtk-tk-support/vtk:9.0.0
```
