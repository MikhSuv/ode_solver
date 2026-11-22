module rk4
  use precision_mod
  use rhs_function_interface
  implicit none
  
  contains
    function solve_rk4(f, x_0, h, t_end) result(x)
      procedure(ode_rhs) :: f
      real(dp), intent(in) :: x_0(:)
      real(dp), intent(in) :: h
      real(dp), intent(in) :: t_end
      real(dp), allocatable :: x(:,:)

      integer :: n, i
      real(dp) :: k(4, size(x_0)), t
      n = int(t_end / h)
      allocate(x(0:n-1, size(x_0)))
      x(0, :) = x_0

      do i = 1, n
        t = real(i, dp) * h
        k(1, :) = h * f(t, x(i-1, :))
        k(2, :) = h * f(t + 0.5_dp * h, x(i-1, :) + 0.5_dp * k(1, :))
        k(3, :) = h * f(t + 0.5_dp * h, x(i-1, :) + 0.5_dp * k(2, :)) 
        k(4, :) = h * f(t + h, x(i-1, :) + k(3, :))

        x(i, :) = x(i-1, :) + (k(1, :) + 2.0_dp * k(2, :) + &
        2.0_dp * k(3, :) + k(4, :)) / 6.0_dp
      end do

    end function solve_rk4

end module rk4
