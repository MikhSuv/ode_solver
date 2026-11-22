cmake_minimum_required(VERSION 3.20)

project(ode_solve LANGUAGES Fortran)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

set(ODE_STANDARD_FLAGS -std=f2018 -pedantic-errors)

set(ODE_WARNING_FLAGS
  -Wall
  -Wextra
  -Wpedantic
  -Wimplicit-interface
  -Wsurprising
)

set(ODE_DEBUG_COMPILE_FLAGS
  -g3
  -O0
  -fcheck=all
  -fbacktrace
  -finit-real=snan
  -finit-integer=-999999
  -ffpe-trap=invalid,zero,overflow
  -fno-omit-frame-pointer
  -fsanitize=address,undefined
)

set(ODE_DEBUG_LINK_FLAGS
  -fsanitize=address,undefined
  -fno-omit-frame-pointer
)

set(ODE_RELEASE_COMPILE_FLAGS
  -O3
  -march=native
  -funroll-loops
  -flto
  -fno-math-errno
)

set(ODE_RELEASE_LINK_FLAGS
  -flto
)

function(configure_ode_target target)
  target_compile_options(${target} PRIVATE ${ODE_STANDARD_FLAGS})
  target_compile_options(${target} PRIVATE ${ODE_WARNING_FLAGS})

  foreach(flag IN LISTS ODE_DEBUG_COMPILE_FLAGS)
    target_compile_options(${target} PRIVATE $<$<CONFIG:Debug>:${flag}>)
  endforeach()

  foreach(flag IN LISTS ODE_RELEASE_COMPILE_FLAGS)
    target_compile_options(${target} PRIVATE $<$<CONFIG:Release>:${flag}>)
  endforeach()
endfunction()

function(setup_library target)
  set(MOD_DIR "${CMAKE_CURRENT_BINARY_DIR}/modules/${target}")

  file(MAKE_DIRECTORY "${MOD_DIR}")

  set_target_properties(${target} PROPERTIES
    Fortran_MODULE_DIRECTORY "${MOD_DIR}"
  )

  target_include_directories(${target} PUBLIC
    "${MOD_DIR}"
  )
endfunction()

add_library(ode_solver STATIC
  src/precision_mod.f90
  src/write_result.f90
  src/problem.f90
  src/rhs_function_interface.f90
  src/rk4.f90
)

setup_library(ode_solver)
configure_ode_target(ode_solver)

add_executable(ode_solve
  app/main.f90
)

target_link_libraries(ode_solve PRIVATE ode_solver)
configure_ode_target(ode_solve)

foreach(flag IN LISTS ODE_DEBUG_LINK_FLAGS)
  target_link_options(ode_solve PRIVATE $<$<CONFIG:Debug>:${flag}>)
endforeach()

foreach(flag IN LISTS ODE_RELEASE_LINK_FLAGS)
  target_link_options(ode_solve PRIVATE $<$<CONFIG:Release>:${flag}>)
endforeach()
