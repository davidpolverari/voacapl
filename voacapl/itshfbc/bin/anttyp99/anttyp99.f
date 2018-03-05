c--------------------------------------------------------------
c# anttyp99.for
C***********************************************************************
      PROGRAM anttyp99
*    +               (run_directory,mode)
C***********************************************************************
c Calculate an exteranl antenna file.
c Assumes data is in the format of:
c       ..\antennas\samples\sample.90
c Execute with:
c    anttyp99 directory mode
c where:
c    directory = full pathname to the RUN directory (e.g. c:\ITSHFBC\RUN)
c    mode      = (blank) = Point-to-Point
c              = a = Area Coverage
C***********************************************************************
      use cantenna
      use Cant99

      character (len=80) :: filename, gainfile
      character (len=120) :: run_directory
      character (len=1) :: mode
      
C.....START OF PROGRAM
      call GET_COMMAND_ARGUMENT(1, run_directory)
      nch_run=len(trim(run_directory))
      if(nch_run.lt.3) go to 930
      
      call GET_COMMAND_ARGUMENT(2, mode)

      open(21,file=run_directory(1:nch_run)//'/anttyp99.dat', status='old',err=900)
      rewind(21)
      read(21,*,err=920) idx          !  antenna index #, GAINxx.dat
      read(21,'(a)',err=920) antfile  !  antenna file name
      read(21,*,err=920) xfqs         !  starting frequency
      read(21,*,err=920) xfqe         !  ending frequency
      read(21,*,err=920) beammain     !  main beam (deg from North)
      read(21,*,err=920) offazim      !  off azimuth (deg from North)
      close(21)
      nch=len(trim(antfile))
      filename=run_directory(1:nch_run-3)//'antennas/'//antfile(1:nch)

      lua=42
      call ant99_read(filename,21,lua,*910)
      diel=parms(3)         !  dielectric constant
      cond=parms(4)         !  conductivity
      write(gainfile,1) run_directory(1:nch_run),idx
1     format(a,5h/gain,i2.2,4h.dat)
      open(22,file=gainfile)
      rewind(22)
      write(22,'(a)') 'HARRIS99  '//title
c****************************************************************
      if(mode.ne.' ') go to 200     !  area coverage
c*****Point-to-Point mode
      write(22,2) xfqs,xfqe,beammain,offazim,cond,diel
2     format(2f5.0,2f7.2,2f10.5)
      azimuth=offazim
      do ifreq=1,30
        freq=ifreq
        if(freq.ge.xfqs .and. freq.le.xfqe) then    !  in frequency range
            do iel=0,90
                elev=iel
                call ant99_calc(freq,azimuth,elev,gain(iel+1),aeff,*940)
            end do
        else                                        !  outside freq range
            aeff=0.
            do iel=0,90
                gain(iel+1)=0.
            end do
        end if
        write(22,3) ifreq,aeff,gain
3       format(i2,f6.2,(T10,10F7.3))
      end do
      go to 500
c****************************************************************
c*****Area Coverage mode
200   write(22,2) 2.0,xfqe,beammain,-999.,cond,diel
      freq=xfqs
      call ant99_calc(freq,0.,8.,g,aeff,*940)
      write(22,201) freq,aeff
201   format(10x,f7.3,'MHz eff=',f10.3)
      do iazim=0,359
        azimuth=iazim
        do iel=0,90
            elev=iel
220         call ant99_calc(freq,azimuth,elev,gain(iel+1),aeff,*940)
        end do
250     write(22,251) iazim,gain
251     format(i5,(T10,10F7.3))
      end do
c****************************************************************
500   call ant99_close
      close(22)
c****************************************************************
      go to 999
c****************************************************************
900   write(*,901) run_directory(1:nch_run)//'/anttyp99.dat' !jw
901   format(' In anttyp99, could not OPEN file=',a)
      stop 'OPEN error in anttyp99 at 900'
910   write(*,911) filename
911   format(' In anttyp99, error READing file=',a)
      stop 'READ error in anttyp99 at 910'
920   write(*,921) run_directory(1:nch_run)//'/anttyp99.dat' !jw
921   format(' In anttyp99, error READing file=',a)
      stop 'READ error in anttyp99 at 920'
c***********************************************************************
930   write(*,931)
931   format('anttyp99 must be executed:',/
     +  '1. Point-to-Point:',/
     +  '   anttyp99.exe run_directory',/,
     +  '4. Area Coverage:',/
     +  '   icepacw.exe run_directory a')
      write(*,932)
932   format(/
     +  'Where:',/
     +  '      run_directory = full pathname to RUN directory',/
     +  '                      (e.g. /home/usr_name/itshfbc/run)')
      stop 'anttyp99 not executed properly.'
940   write(*,941) filename
941   format(' In anttyp99, error Calculating from file=',a)
      stop 'READ error in ANTTYP99 at 940'
c***********************************************************************
999   continue
      end
