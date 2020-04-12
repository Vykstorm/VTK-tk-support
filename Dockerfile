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
RUN git clone https://gitlab.kitware.com/vtk/vtk.git VTK
RUN apt install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev
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
         # tk options
         VTK_USE_TK=ON \
         /VTK/
# Compile VTK
RUN cd VTK-build \
    && make -j 4 \
    && make install
RUN ldconfig
# Install tkinter
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y tzdata python3-tk
# Verify installations
ENV VTK_DIR=/usr/local/lib/python${PYTHON_VERSION}/site-packages
RUN export PYTHONPATH=$VTK_DIR \
    && python -c "import tkinter" \
    && python -c "import vtk" \
    && python -c "from vtk.tk.vtkTkRenderWindowInteractor import vtkTkRenderWindowInteractor"
# Install setuptools & wheel
RUN python -m pip install --user --upgrade setuptools wheel
COPY setup.py $VTK_DIR/setup.py
RUN cd $VTK_DIR \
    && python setup.py sdist bdist_wheel \
    && cp -r -v dist /
