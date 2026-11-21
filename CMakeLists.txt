cmake_minimum_required(VERSION 3.20)

project(integr LANGUAGES Fortran)

add_library(integrator STATIC
        src/precision_mod.f90
)

add_executable(integr
        app/main.f90
)

target_link_libraries(integr PRIVATE integrator)
