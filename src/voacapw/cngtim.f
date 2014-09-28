c###cngtim.for
      FUNCTION CNGTIM(TIME,XTHETA,ISW)
C--------------------------------
C     /////////////////////////////////////////////
C
C     IF ISW=1
C     THIS FUNCTION CONVERTS UNIVERSAL TIME (TIME GREATER THAN
C     OR EQUAL TO ZERO BUT LESS THAN 24) IN HOURS TO LOCAL TIME
C     AT LOCAL REFRENCE LONGITUDE (THETA GREATER THAN OR EQUAL
C     TO ZERO AND LESS THAN OR EQUAL TO 360 DEGREES) IN DEGREES EAST
C
C
C     IF ISW=-1
C     THIS FUNCTION CONVERTS LOCAL TIME (TIME GREATER THAN
C     OR EQUAL TO ZERO BUT LESS THAN 24)
C     AT LOCAL REFRENCE LONGITUDE (THETA GREATER THAN OR EQUAL
C     TO ZERO AND LESS THAN OR EQUAL TO 360 DEGREES) IN DEGREES EAST
C     TO UNIVERSAL TIME
C
C
C     FUNCTION VALUE IS ZERO IF THERE IS NO DAY CHANGE
C
C     FUNCTION VALUE IS 1 IF THE DAY SHOULD BE ADVANCED
C
C     FUNCTION VALUE IS -1 IF THE DAY SHOULD BE RETARDED
C
C     /////////////////////////////////////////////
      IF(XTHETA) 80,75,85
   75 CNGTIM=0
      RETURN
   80  THETA=360. + XTHETA
      GO TO 90
   85 THETA=XTHETA
   90  CONTINUE
C
C     THE FUNCTION STARTS HERE
C
      INT1 = THETA / 180.
      INT2 = THETA / 360.
      FINT1 = INT1
      FINT2 = INT2
      FISW = ISW
      TIME = TIME + FISW * (THETA / 15.0 - FINT1 * 24. + FINT2 * 24.)
      INT1 = (TIME - 23.99999999) / 24.0
      INT2 = TIME / 24.0
      CNGTIM = INT1 + INT2
      IF (TIME)100, 105, 105
  100 TIME = TIME + 24.
  105 TIME = TIME - FINT2 * 24.
  110 IF(TIME) 115, 120, 120
  115 TIME = TIME + 24.
      GO TO 110
  120 IF(TIME - 24.) 130, 130, 125
  125 TIME = TIME - 24.
      GO TO 110
  130 CONTINUE
      RETURN
      END
C--------------------------------
