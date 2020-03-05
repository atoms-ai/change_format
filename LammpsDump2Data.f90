PROGRAM DUMP2DATA
!Sumit Suresh (sumit.suresh@uconn.edu)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 		BOX PROPERTIES 			!!!!!!!!!!!!!!!!!!!!!!!!!!!
        REAL :: XLO,XHI,YLO,YHI,ZLO,ZHI

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 		SNAPSHOT ATOMS AND TIME !!!!!!!!!!!!!!!!!!!!!!!!!!!
		    INTEGER :: NAN,TIME, COUNT

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 		ATOMIC PROPERTIES 		!!!!!!!!!!!!!!!!!!!!!!!!!!!
		    INTEGER, ALLOCATABLE, DIMENSION(:)	:: ID, KTYPE
		    REAL, ALLOCATABLE, DIMENSION(:)   	:: X,Y,Z,VX,VY,VZ,S1,S2,S3

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 STRINGS		 		!!!!!!!!!!!!!!!!!!!!!!!!!!!
		    CHARACTER(LEN=80) 	:: time_str, atom_str, box_str, dump_str

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Read the CMMG datafile		 		!!!!!!!!!!!!!!!!!!!!!!!!!!!

        OPEN (UNIT = 14,FILE='../dump.FILENAME')

        REWIND 14


        READ(14,*) time_str
        READ(14,*) TIME
        READ(14,*) atom_str
        READ(14,*) NAN

        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Allocate arrays - start		 		!!!!!!!!!!!!!!!!!!!!!!!!!!!
                ALLOCATE (ID(NAN),KTYPE(NAN),X(NAN),Y(NAN),Z(NAN),VX(NAN),VY(NAN),VZ(NAN),S1(NAN),S2(NAN),S3(NAN))
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Allocate arrays - end		 			!!!!!!!!!!!!!!!!!!!!!!!!!!!
        READ(14,*) box_str
        READ(14,*) XLO, XHI
        READ(14,*) YLO, YHI
        READ(14,*) ZLO, ZHI
        READ(14,*) dump_str
        DO J=1,NAN
          READ(14,*) ID(J),KTYPE(J),X(J),Y(J),Z(J),VX(J),VY(J),VZ(J),S1(J),S2(J),S3(J)
          IF(KTYPE(J).EQ.3) THEN
            KTYPE(J)=1
          ELSE
            KTYPE(J)=2
          END IF
        END DO

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 WRITE the modified LAMMPS datafile		 !!!!!!!!!!!!!!!!!!!!!!!!!!!

        OPEN (UNIT = 16,FILE='../data.FILENAME')

        WRITE(16,"(A)") "Lammps Datafile "
        WRITE(16,"(A)") ""
        WRITE(16,*) NAN, "atoms"
        WRITE(16,"(A)") ""
        WRITE(16,"(A)") "2 atom types"
        WRITE(16,"(A)") ""
        WRITE(16,*) XLO,XHI, "xlo xhi"
        WRITE(16,*) YLO,YHI, "ylo yhi"
        WRITE(16,*) ZLO,ZHI, "zlo zhi"
        WRITE(16,"(A)") ""
        WRITE(16,"(A)") "Atoms"
        WRITE(16,"(A)") ""
        WRITE(16,174) (ID(J),KTYPE(J),X(J),Y(J),Z(J),J=1,NAN)
        WRITE(16,"(A)") ""
        WRITE(16,"(A)") "Velocities"
        WRITE(16,"(A)") ""
        WRITE(16,175) (ID(J),VX(J),VY(J),VZ(J),J=1,NAN)


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!					FORMATS			 				!!!!!!!!!!!!!!!!!!!!!!!!!!!

!		Time FORMAT
171   FORMAT(I10)
!		NAN FORMAT
172   FORMAT(I0,1x,"(A)")
!		Box dimensions FORMAT
173   FORMAT(F0.2,1x,F0.2,1x,"(A)")
!		dump FORMAT
174   FORMAT(I0,1x,I0,1x,F0.2,1x,F0.2,1x,F0.2)
175   FORMAT(I0,1x,F0.2,1x,F0.2,1x,F0.2)
!		Other FORMAT
199   FORMAT(I10,1x,(a))

END PROGRAM DUMP2DATA
