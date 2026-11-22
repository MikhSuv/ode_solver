! Definition of the concrete Cauchy problem to be integrated.
!
! The system is a four-dimensional ODE
!
!   x1' =  x3
!   x2' =  x4
!   x3' = -x1 - 2*x1*x2
!   x4' = -x2 - x1^2 + x2^2
!
! integrated from t = 0 with a constant step h up to t_end.
module problem_conditions
  use precision_mod
  implicit none

  ! ! Number of components of the state vector X.
  ! integer, parameter :: dim = 4

  ! End of the integration interval.
  real(dp), parameter :: t_end = 100.0_dp

  ! Initial state X(0).
  real(dp), parameter :: x_0(*) = [0.1_dp, 0.0_dp, 0.0_dp, 0.4_dp]

  ! Order n of the Adams methods.
  integer, parameter :: adams_order = 4

  ! Constant integration step.
  real(dp), parameter :: h = 1.0e-4_dp

contains
  ! Right-hand side f(t, X) of the system.
  !
  ! Arguments:
  !   t - current time;
  !   x - state vector.
  ! Result:
  !   y - derivative dX/dt of the same size as x.
  pure function f(t, x) result(y)
    real(dp), intent(in) :: t
    real(dp), intent(in) :: x(:)
    real(dp) :: y(size(x))

    y(1) = x(3)
    y(2) = x(4)
    y(3) = -x(1) - 2.0_dp * x(1) * x(2)
    y(4) = -x(2) - x(1) * x(1) + x(2) * x(2)
  end function f
end module problem_conditions
