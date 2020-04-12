
from setuptools import setup

setup(
    name="vtk",
    version="9.0.0",
    author="VTK Community",
    author_email="vtk-developers@vtk.org",
    url="https://vtk.org",
    license="BSD License",
    description="VTK is an open-source toolkit for 3D computer graphics, image processing, and visualization",
    long_description="""VTK is an open-source, cross-platform library that provides developers with an extensive suite of software tools for 3D computer graphics, image processing,and visualization. It consists of a C++ class library and several interpreted interface layers including Tcl/Tk, Java, and Python. VTK supports a wide variety of visualization algorithms including scalar, vector, tensor, texture, and volumetric methods, as well as advanced modeling techniques such as implicitmodeling, polygon reduction, mesh smoothing, cutting, contouring, and Delaunay triangulation. VTK has an extensive information visualization framework and a suite of 3D interaction widgets. The toolkit supports parallel processing and integrates with various databases on GUI toolkits such as Qt and Tk.""",
    classifiers=[
        "Classifier: License :: OSI Approved :: BSD License",
        "Classifier: Programming Language :: Python",
        "Classifier: Programming Language :: C++",
        "Classifier: Development Status :: 4 - Beta",
        "Classifier: Intended Audience :: Developers",
        "Classifier: Intended Audience :: Education",
        "Classifier: Intended Audience :: Healthcare Industry",
        "Classifier: Intended Audience :: Science/Research",
        "Classifier: Topic :: Scientific/Engineering",
        "Classifier: Topic :: Scientific/Engineering :: Medical Science Apps",
        "Classifier: Topic :: Scientific/Engineering :: Information Analysis",
        "Classifier: Topic :: Software Development :: Libraries",
        "Classifier: Operating System :: POSIX",
        "Classifier: Operating System :: Unix"
    ],
    python_requires=">=3.7",
    py_modules=["vtk"],
    packages=["vtkmodules",
        "vtkmodules.numpy_interface",
        "vtkmodules.tk",
        "vtkmodules.util",
        "vtkmodules.test"],
    package_data={"vtkmodules":["*.so"]}

)
