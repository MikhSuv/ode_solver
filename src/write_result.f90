module writeresult
  use precision_mod
  use iso_fortran_env, only: error_unit
  implicit none

  contains

    ! Reports a fatal I/O problem on stderr and stops with a non-zero status
    subroutine report_error(message)
      character(len=*), intent(in) :: message

      write(error_unit, '(a)') 'io_mod: ' // message
      error stop 1
    end subroutine report_error

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
        t = real(i-1, dp) * h
        write(iunit, '(*(es24.16e3,1x))') t, x(i, :)
      end do
      close(iunit)
    end subroutine write_result
end module writeresult
