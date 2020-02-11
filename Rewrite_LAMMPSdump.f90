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

        COUNT=0   ! Counter initialised to zero, will read the number of rigid substrate atoms

        OPEN (UNIT = 14,FILE='../dump.imp1kmps.6000')

        READ(14,"(A)") time_str
        READ(14,*) TIME
        READ(14,"(A)") atom_str
        READ(14,*) NAN

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Allocate arrays - start		 		!!!!!!!!!!!!!!!!!!!!!!!!!!!

		ALLOCATE (ID(NAN),KTYPE(NAN),X(NAN),Y(NAN),Z(NAN),VX(NAN),VY(NAN),VZ(NAN),S1(NAN),S2(NAN),S3(NAN))

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		 Allocate arrays - end		 			!!!!!!!!!!!!!!!!!!!!!!!!!!!
        READ(14,"(A)") box_str
        READ(14,*) XLO,XHI
        READ(14,*) YLO,YHI
        READ(14,*) ZLO,ZHI
        READ(14,"(A)") dump_str
        DO J=1,NAN
         READ(14,*) ID(J),X(J),Y(J),Z(J),VX(J),VY(J),VZ(J),S1(J),S2(J),S3(J)

         !!!!!!!! Special case where ktype wasn't output, rigid particles have all velocities as zero, hence they will be assigned type 2, the rest being type 1!!!!!!!!!!!!!!!
          IF((VX(J).EQ.0).AND.(VY(J).EQ.0).AND.(VZ(J).EQ.0)) THEN
            KTYPE(J) = 2
            COUNT = COUNT+1
          ELSE
            KTYPE(J) = 1
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
        WRITE(16,"(A)") "ITEM: ATOMS id type x y z"
        WRITE(16,174) (ID(J),KTYPE(J),X(J),Y(J),Z(J),J=1,NAN) ! KTYPE in dump is same as KHIST in CMMG

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!					FORMATS			 				!!!!!!!!!!!!!!!!!!!!!!!!!!!

!		Time FORMAT
171   FORMAT(F10.4)
!		NAN FORMAT
172   FORMAT(I0)
!		Box dimensions FORMAT
173   FORMAT(F0.2,1x,F0.2)
!		dump FORMAT
174   FORMAT(I0,1x,I0,1x,F0.2,1x,F0.2,1x,F0.2)
!		Other FORMAT
199   FORMAT(I10,1x,(a))

END PROGRAM DUMPRW
