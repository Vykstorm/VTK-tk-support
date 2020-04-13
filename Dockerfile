ARG BASE=ubuntu:18.04
FROM $BASE
ARG PYTHON_VERSION=3.7
# Install dependencies
RUN apt update && apt install -y \
    g++ \
    git \
    pkg-config \
    locales \
    curl \
    make \
    libssl-dev \
    mesa-utils \
    libsm6 \
    libxrender1 \
    libfontconfig \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python3-pip \
    && apt clean \
    && locale-gen "en_US.UTF-8"
# Install and configure pip & python
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python${PYTHON_VERSION} get-pip.py --prefix=/usr/local/   \
    && rm get-pip.py \
    && update-alternatives --install /usr/bin/python python${PYTHON_VERSION} /usr/bin/python${PYTHON_VERSION} 1 \
    && update-alternatives --install /usr/bin/pip pip${PYTHON_VERSION} /usr/local/bin/pip${PYTHON_VERSION} 1
# Setup locale configuration
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
# Get CMake
RUN git clone https://github.com/Kitware/CMake.git -b release
# Compile & install CMake
RUN cd CMake \
    && ./bootstrap --parallel=4 \
    && make -j 4 \
    && make install
# Get VTK source code
RUN git clone https://gitlab.kitware.com/vtk/vtk.git VTK -b release
# Dependencies for VTK
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y \
        libglu1-mesa-dev \
        freeglut3-dev    \
        mesa-common-dev  \
        tzdata           \
        tcl-dev          \
        tk-dev          \
        python3-tk
# Configure VTK
RUN mkdir VTK-build \
    && cd VTK-build \
    && cmake -j 4 \
        # general options
         -DBUILD_SHARED_LIBS=ON                                          \
         -DBUILD_TESTING=OFF                                             \
         -DVTK_FORBID_DOWNLOADS=ON                                       \
         -DCMAKE_BUILD_TYPE=Release                                      \
         # python wrapping options
         -DVTK_WRAP_PYTHON=ON                                            \
         -DVTK_PYTHON_VERSION=3                                          \
         -DPYTHON_EXECUTABLE:PATH=/usr/bin/python                        \
         -DPYTHON_INCLUDE_DIR:PATH=/usr/include/python${PYTHON_VERSION}  \
         -DPYTHON_LIBRARY:PATH=/usr/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}m-x86_64-linux-gnu/libpython${PYTHON_VERSION}.so \
         -DVTK_WHEEL_BUILD=ON                                            \
         -DVTK_USE_TK=ON                                                 \
         /VTK/ || \
         cat ./CMakeFiles/CMakeError.log | grep VTK_USE_TK
# Compile VTK
RUN cd VTK-build \
    && make -j 4 \
    && make install
RUN ldconfig
# Verify installations
ENV VTK_DIR=/usr/local
RUN export PYTHONPATH=$VTK_DIR \
    && python -c "import tkinter" \
    && python -c "import vtk" \
    && python -c "from vtk.tk.vtkTkRenderWindowInteractor import vtkTkRenderWindowInteractor"
# Install setuptools & wheel
RUN python -m pip install --user --upgrade setuptools wheel
# Build wheels with setup script
RUN cd /VTK-build \
    && printf "from os.path import dirname, join\nimport sys\nsys.path.append(join(dirname(__file__), 'vtkmodules'))\n\n" >> vtk.py \
    && python setup.py bdist_wheel bdist_egg \
    && cp -r -v dist /
