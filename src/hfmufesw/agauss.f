C FUNCTION AGAUSS             (NEXT)
      FUNCTION AGAUSS (XFUNCT, H2)
C 
C     AGAUSS - GAUSSIAN INTEGRATION IN WHICH 48 ABSCISSAS AND WEIGHT
C        FACTORS ARE USED.  XFUNCT IS THE FUNCTION TO BE INTEGRATED AND 
C        H2 IS THE ELEMENT LENGTH WHICH DETERMINES THE INTEGRATION
C        LIMITS.
C     SEE ABRAMOWITZ AND STEGUN, HANDBOOK OF MATHEMATICAL FUNCTIONS,
C     P 887 (EQU 25.4.30), P917 (WEIGHT AND ABSCISSA VALUES). 
C     THE WEIGHTS AND ABSCISSAS ARE IN COMMON /WEIGHT/ AND ARE SET
C     IN SUBROUTINE GAIN IN A DATA STATEMENT. 
C 
      COMMON /WAITS /HH (48), XI (48) 
C 
      EXTERNAL XFUNCT 
C 
C 
C.....INITIALIZE, INTEGRATE, AND TEST...................................
      DATA TESTD / 5.0E-08/ 
      M = 1 
      ANS = 0.0 
      CHECK = 1000.0
      IF (H2 .EQ. 0.0) GO TO 125
 100  AGAUSS = 0.0
      IF (M .LT. 1) GO TO 130 
      DO 110 L = 1, M 
      FL = L
      FM = M
      BOLIM = - H2 + 2.0 * H2 * (FL - 1.0) / FM 
      UPLIM = - H2 + 2.0 * H2 * FL / FM 
      SUM = 0.0 
      DO 105 I = 1, 48
      S = 0.5 * ((UPLIM - BOLIM) * XI (I) + UPLIM + BOLIM)
 105  SUM = SUM + HH (I) * XFUNCT (S) 
      SUM = 0.5 * (UPLIM - BOLIM) * SUM 
 110  AGAUSS = AGAUSS + SUM 
 130  CONTINUE
      TEST = ABS ((AGAUSS - ANS) / AGAUSS)
      IF (TEST .GT. 0.0005) GO TO 115 
      IF (TEST .LE. TESTD) GO TO 125
 115  IF (M .GE. 10) GO TO 120
      CHECK = TEST - TESTD
      M = M + 1 
      ANS = AGAUSS
      GO TO 100 
 120  IF (CHECK .GE. TEST) GO TO 125
      AGAUSS = ANS
 125  RETURN
      END 
