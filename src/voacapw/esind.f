c###esind.for
      SUBROUTINE ESIND
C--------------------------------
C
C     THIS ROUTINE EVALUATES THE SPORADIC E (ES) PARAMETERS
C     NOTE THE CRITICAL FREQUENCIES ARE THE MAXIMUM OF REGULAR E AND THE
C     SPORADIC E.  PSC IS USUALLY 0.70 TO OBTAIN MEDIAN LOSSES.
C
C  GMT IS UNIVERSAL TIME
C
      COMMON / PSCA / PSC(4), PSCB(4), IPSC
      COMMON /A11 /GAMMA (6)
      COMMON /ES /FS (3, 5), HS (5)
      COMMON /RON /CLAT(5), CLONG(5), GLAT(5), RD(5), FI(3,5), YI(3,5),
     1HI(3,5), HPRIM(30,5), HTRUE(30,5), FVERT(30,5),KM,KFX, AFAC(30,5),
     2HTR(50,3), FNSQ(50,3)
      IF (KM .LT. 1) GO TO 105
      DO 100 II = 1, KM
C.....HS(II) IS THE HEIGHT OF REFLECTION
      HS (II) = 110.
C.....CALL SUBROUTINE VERSY FOR THE EVALUATION OF THE FOURIER EXPANSION
      CALL VERSY(1, 3, II)
C.....FS(1,II) IS THE CRITICAL FREQUENCY LOWER DECILE
C.....FS(2,II) IS THE CRITICAL FREQUENCY MEDIAN
C.....FS(3,II) IS THE CRITICAL FREQUENCY UPPER DECILE
      FS (1, II) = GAMMA (3) * PSC (4)
      FS (2, II) = GAMMA (2) * PSC (4)
      FS (3, II) = GAMMA (1) * PSC (4)
  100 CONTINUE
  105 RETURN
      END
C--------------------------------
C--------------------------------
