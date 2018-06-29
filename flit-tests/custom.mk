# This file is included at the end of the copied Makefile.  If you have some
# things you want to change about the Makefile, it is best to do it here.

CUB_DIR        ?= ./cub
CUDA_DIR       ?= /usr/local/cuda
MFEM_DIR       ?= $(HOME)/home/mfem/mfem-master
RAJA_DIR       ?= $(HOME)/usr/local/raja/last
MPI_HOME       ?= $(HOME)/usr/local/openmpi/3.0.0
RAJA           := ../raja
KERNELS        := $(RAJA)/kernels

NV_ARCH        ?= -arch=sm_60

# additional source files to compile other than what is in '.' and 'tests/'
# since those directories are added by a wildcard.
KERNEL_FILES   :=
KERNEL_FILES   += $(wildcard $(KERNELS)/*.cpp)
KERNEL_FILES   += $(wildcard $(KERNELS)/blas/*.cpp)
KERNEL_FILES   += $(wildcard $(KERNELS)/force/*.cpp)
KERNEL_FILES   += $(wildcard $(KERNELS)/geom/*.cpp)
KERNEL_FILES   += $(wildcard $(KERNELS)/maps/*.cpp)
KERNEL_FILES   += $(wildcard $(KERNELS)/mass/*.cpp)
KERNEL_FILES   += $(wildcard $(KERNELS)/quad/*.cpp)
KERNEL_FILES   += $(wildcard $(KERNELS)/share/*.cpp)

RAJA_FILES     :=
RAJA_FILES     += $(wildcard $(RAJA)/config/*.cpp)
RAJA_FILES     += $(wildcard $(RAJA)/fem/*.cpp)
RAJA_FILES     += $(wildcard $(RAJA)/general/*.cpp)
RAJA_FILES     += $(wildcard $(RAJA)/linalg/*.cpp)
RAJA_FILES     += $(wildcard $(RAJA)/tests/*.cpp)

CUDA_FILES     :=
CUDA_FILES     += $(wildcard $(KERNELS)/blas/*.cu)
CUDA_FILES     += $(wildcard $(RAJA)/linalg/*.cu)

SOURCE         += $(wildcard ../*.cpp)
SOURCE         += $(KERNEL_FILES)
SOURCE         += $(RAJA_FILES)

# required compiler flags
# for example, include directories
#   CC_REQUIRED += -I<path>
# or defines
#   CC_REQUIRED += -DDEBUG_ENABLED=1
CC_REQUIRED    += --expt-extended-lambda # for cuda
CC_REQUIRED    += --restrict
CC_REQUIRED    += -DUSE_CUDA
CC_REQUIRED    += -D__LAMBDA__
CC_REQUIRED    += -D__RAJA__
CC_REQUIRED    += -D__TEMPLATES__
CC_REQUIRED    += -I$(CUDA_DIR)/samples/common/inc
CC_REQUIRED    += -I$(MFEM_DIR)
CC_REQUIRED    += -I$(MFEM_DIR)/../hypre-2.10.0b/src/hypre/include
CC_REQUIRED    += -I$(MPI_HOME)/include
# Note: The local cub directory needs to be included before raja because some
#       files shadow the same header files found in raja.
CC_REQUIRED    += -I../cub
CC_REQUIRED    += -I$(RAJA_DIR)/include
CC_REQUIRED    += $(NV_ARCH)
CC_REQUIRED    += -Xcompiler -fopenmp
CC_REQUIRED    += -m64
CC_REQUIRED    += -x=cu

# required linker flags
# for example, link libraries
#   LD_REQUIRED += -L<library-path> -l<library-name>
# or rpath
#   LD_REQUIRED += -Wl,-rpath=<abs-path-to-library-dir>
LD_REQUIRED    += -L$(MFEM_DIR) -lmfem
LD_REQUIRED    += -L$(MFEM_DIR)/../hypre-2.10.0b/src/hypre/lib -lHYPRE
LD_REQUIRED    += -L$(MFEM_DIR)/../metis-4.0 -lmetis
LD_REQUIRED    += -lrt
LD_REQUIRED    += -fopenmp
LD_REQUIRED    += $(RAJA_DIR)/lib/libRAJA.a
LD_REQUIRED    += -Wl,-rpath -Wl,$(CUDA_DIR)/lib64
LD_REQUIRED    += -L$(CUDA_DIR)/lib64 -lcuda -lcudart -lcudadevrt -lnvToolsExt
LD_REQUIRED    += -ldl

# compiler and linker flags respectively - specifically for a dev build
# - DEV_CFLAGS:   non-recorded compiler flags (such as includes)
# - DEV_LDFLAGS:  linker flags (also not under test)
DEV_CFLAGS     +=
DEV_LDFLAGS    +=

# wrapper around the running of the test executable when run through the
# Makefile.
# For example, to run a test incorporating MPI, you could use
#   RUN_WRAPPER := mpirun -n4
RUN_WRAPPER    :=

