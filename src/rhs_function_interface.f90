module rhs_function_interface
  use precision_mod
  implicit none

  abstract interface
    function ode_rhs(t, x) result(dx)
      import :: dp
      real(dp), intent(in) :: t
      real(dp), intent(in) :: x(:)
      real(dp) :: dx(size(x))
    end function ode_rhs
  end interface
end module rhs_function_interface
