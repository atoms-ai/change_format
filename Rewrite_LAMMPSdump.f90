PROGRAM DUMPRW
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

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Read the LAMMPS dumpfile		 		!!!!!!!!!!!!!!!!!!!!!!!!!!!

        OPEN (UNIT = 14,FILE='../dump.imp1kmps.6000')

        READ(14,"(A)") time_str
        READ(14,*) TIME
        READ(14,"(A)") atom_str
        READ(14,*) NAN

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Allocate arrays - start		 		!!!!!!!!!!!!!!!!!!!!!!!!!!!

		ALLOCATE (ID(NAN),KTYPE(NAN),X(NAN),Y(NAN),Z(NAN),VX(NAN),VY(NAN),VZ(NAN),S1(NAN),S2(NAN),S3(NAN))


    COUNT=0
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Allocate arrays - end		 			!!!!!!!!!!!!!!!!!!!!!!!!!!!
        READ(14,"(A)") box_str
        READ(14,*) XLO,XHI
        READ(14,*) YLO,YHI
        READ(14,*) ZLO,ZHI
        READ(14,"(A)") dump_str
        DO J=1,NAN
         READ(14,*) ID(J),X(J),Y(J),Z(J),VX(J),VY(J),VZ(J),S1(J),S2(J),S3(J)
          IF((VX(I).EQ.0).AND.(VY(I).EQ.0).AND.(VZ(I).EQ.0)) THEN
            KTYPE(I) = 2
            COUNT = COUNT+1
          ELSE
            KTYPE(I) = 1
          END IF
        end do

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Defining simulation box acc. to CMMG code	 			!!!!!!!!!!!!!!!!!!!!!!!!!!!

      print*, "Number of atoms in the substrate is ", COUNT

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 WRITE the modified LAMMPS dumpfile		 !!!!!!!!!!!!!!!!!!!!!!!!!!!

        OPEN (UNIT = 16,FILE='dump_rw.6000')

        REWIND 16
        WRITE(16,"(A)") time_str
        WRITE(16,172) TIME
        WRITE(16,"(A)") atom_str
        WRITE(16,172) NAN
        WRITE(16,"(A)") box_str
        WRITE(16,173) XLO, XHI
        WRITE(16,173) YLO, YHI
        WRITE(16,173) ZLO, ZHI
        WRITE(16,"(A)") dump_str
        WRITE(16,*) (IDGG(J),KTYPE(J),X(J),Y(J),Z(J),J=1,NAN) ! KTYPE in dump is same as KHIST in CMMG

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!					FORMATS			 				!!!!!!!!!!!!!!!!!!!!!!!!!!!

!		Time FORMAT
171   FORMAT(F10.4)
!		NAN FORMAT
172   FORMAT(I0)
!		Box dimensions FORMAT
173   FORMAT(F0.2,1x,F0.2)
!		dump FORMAT
174   FORMAT(I0,1x,I0,1x,F0.2,1x,F0.2,1x,F0.2,1x,F0.2,1x,F0.2,1x,F0.2)
!		Other FORMAT
199   FORMAT(I10,1x,(a))

END PROGRAM DUMPRW
