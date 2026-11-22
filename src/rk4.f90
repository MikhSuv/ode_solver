! Classical fourth-order Runge-Kutta integrator for the Cauchy problem
!   dX/dt = f(t, X),  X(0) = x_0,
! with a constant step h.
module rk4
  use precision_mod
  use rhs_function_interface
  implicit none

contains
  ! Integrate the system from t = 0 to t_end.
  !
  ! Arguments:
  !   f     - right-hand side of the system;
  !   x_0   - initial state X(0);
  !   h     - constant integration step;
  !   t_end - end of the integration interval.
  ! Result:
  !   x - array of shape (0:n, size(x_0)); row i stores X(t_i), t_i = i*h.
  !
  ! The number of steps n is the largest integer such that n*h <= t_end.
  function solve_rk4(f, x_0, h, t_end) result(x)
    procedure(ode_rhs) :: f
    real(dp), intent(in) :: x_0(:)
    real(dp), intent(in) :: h
    real(dp), intent(in) :: t_end
    real(dp), allocatable :: x(:, :)

    integer :: n, i, d
    real(dp) :: k(4, size(x_0)), t

    if (h <= 0.0_dp) error stop 'solve_rk4: step h must be positive'
    if (t_end < 0.0_dp) error stop 'solve_rk4: t_end must be non-negative'

    d = size(x_0)

    n = floor(t_end / h)

    ! n steps produce n+1 points: t_0 = 0, ..., t_n = n*h.
    allocate(x(0:n, d))
    x(0, :) = x_0

    do i = 1, n
      ! Current time t_i at which the state x(i-1, :) is known.
      t = real(i - 1, dp) * h

      k(1, :) = h * f(t, x(i - 1, :))
      k(2, :) = h * f(t + 0.5_dp * h, x(i - 1, :) + 0.5_dp * k(1, :))
      k(3, :) = h * f(t + 0.5_dp * h, x(i - 1, :) + 0.5_dp * k(2, :))
      k(4, :) = h * f(t + h, x(i - 1, :) + k(3, :))

      x(i, :) = x(i - 1, :) + (k(1, :) + 2.0_dp * k(2, :) + &
        2.0_dp * k(3, :) + k(4, :)) / 6.0_dp
    end do
  end function solve_rk4
end module rk4
