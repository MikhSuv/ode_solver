cmake_minimum_required(VERSION 3.20)

project(ode_solve LANGUAGES Fortran)

add_compile_options(-std=f2018)

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

add_executable(ode_solve
  app/main.f90
)

target_link_libraries(ode_solve PUBLIC ode_solver)
