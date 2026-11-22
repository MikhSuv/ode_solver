module problem_conditions
  use precision_mod
  implicit none

  real(dp), parameter :: t_end = 100.0_dp
  real(dp), parameter :: x_0(*) = [0.1_dp, 0.0_dp, 0.0_dp, 0.4_dp]
  integer, parameter :: adams_order = 4
  real(dp), parameter :: h = 1.0e-4_dp

  contains
    function f(t, x) result(y)
      real(dp), intent(in) :: t
      real(dp), intent(in) :: x(:)
      real(dp) :: y(size(x))
      y(1) = x(3)
      y(2) = x(4)
      y(3) = -x(1) - 2.0_dp*x(1)*x(2)
      y(4) = -x(2) - x(1)*x(1) + x(2)*x(2)
    end function f
end module problem_conditions
