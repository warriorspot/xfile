PROGRAM "tokenize"

DECLARE FUNCTION  Entry ()

EXPORT
DECLARE FUNCTION  Tokenize (in$, @out$[], @delimiter$)
END EXPORT

FUNCTION  Entry ()
	IF LIBRARY(0) THEN RETURN
END FUNCTION

FUNCTION  Tokenize (@in$, @out$[], @delim$)
	XLONG i
	XLONG count
  st$ = ""

  REDIM out$[]
	count = 0

  IF(in$ == "") THEN RETURN 0

  IF(delim$ == "") THEN
    REDIM out$[0] : out$[0] = in$
    RETURN 1
  END IF

	FOR i = 0 TO LEN(in$)
	  IFZ(INSTR(delim$, CHR$(in${i}))) THEN
	    IF(i == LEN(in$)) THEN
				GOSUB Add
				RETURN count
		  END IF
			st$ = st$ + CHR$(in${i})
	  ELSE
		  GOSUB Add
		END IF
	NEXT i
	RETURN count

	SUB Add
		IF(st$ != "") THEN
			size = UBOUND(out$[])
			REDIM out$[size + 1]
			out$[UBOUND(out$[])] = st$
			INC count
			st$ = ""
		END IF
	END SUB
END FUNCTION
END PROGRAM
