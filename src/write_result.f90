! Helpers for writing integration results to a text file.
module writeresult
  use precision_mod
  use iso_fortran_env, only: error_unit
  implicit none

contains
  ! Report a fatal I/O problem on stderr and terminate with a non-zero status.
  subroutine report_error(message)
    character(len=*), intent(in) :: message

    write(error_unit, '(a)') 'io_mod: ' // message
    error stop 1
  end subroutine report_error

  ! Write the solution to filename.
  !
  ! Arguments:
  !   filename - output file name;
  !   x        - array of shape (0:n, D); row i is the state at t = i*h;
  !   h        - integration step used to reconstruct the time values.
  !
  ! Every line contains t followed by the D components of X(t), separated by
  ! spaces:
  !   t  X1  X2  ...  XD
  subroutine write_result(filename, x, h)
    character(len=*), intent(in) :: filename
    real(dp), intent(in) :: x(:, :)
    real(dp), intent(in) :: h

    real(dp) :: t
    integer :: iunit, iostat
    integer :: n, i

    n = size(x, 1)
    open(newunit=iunit, file=filename, status='replace', &
      action='write', iostat=iostat)
    if (iostat /= 0) call report_error('cannot open <' // filename // '> for writing')

    do i = 1, n
      ! The array is indexed from 0, so row i corresponds to t = (i-1)*h.
      t = real(i - 1, dp) * h
      write(iunit, '(*(es24.16e3,1x))') t, x(i, :)
    end do

    close(iunit)
  end subroutine write_result
end module writeresult
