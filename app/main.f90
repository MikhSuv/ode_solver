! Driver program: integrates the test problem with RK4 and writes the result
! to rk4.dat.
program main
  use precision_mod
  use problem_conditions
  use rk4
  use writeresult
  implicit none

  real(dp), allocatable :: x(:, :)

  ! x(i, :) = X(t_i), t_i = i*h, for i = 0..n.
  x = solve_rk4(f, x_0, h, t_end)

  call write_result("rk4.dat", x, h)

  deallocate(x)
end program main
