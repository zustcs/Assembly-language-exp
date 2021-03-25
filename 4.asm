DATAS SEGMENT
	COUNT  DB 100
	TENH   DB '0'
	HOUR   DB '0'
	       DB ':'
	TENM   DB '0'
	MINUTE DB '0'
	       DB ':'
	TENS   DB '0'
	SECOND DB '0',0DH,'$'
DATAS ENDS

CODE SEGMENT
START PROC FAR
	        ASSUME CS:CODE
	        PUSH   DS
	        MOV    AX,0
	        PUSH   AX
	        MOV    AH,07H
	        INT    21H
	        CLI
	        CLD
	        MOV    AX,0000H
	        MOV    DS,AX
	        MOV    SI,0020H
	        LODSW
	        MOV    BX,AX
	        LODSW
	        PUSH   AX
	        PUSH   BX
	        MOV    AX,DATAS
	        MOV    DS,AX
	        ASSUME DS:DATAS
	        MOV    AX,0000H
	        MOV    ES,AX
	        MOV    DI,0020H
	        MOV    AX,OFFSET TIMER
	        STOSW
	        MOV    AX,CS
	        STOSW
	        MOV    AL,00110110B
	        OUT    43H,AL
	        MOV    AX,11932
	        OUT    40H,AL
	        MOV    AL,AH
	        OUT    40H,AL
	        IN     AL,21H
	        PUSH   AX
	        STI
	FOREVER:
	        MOV    DL,0FFH
	        MOV    AH,06H
	        INT    21H
	        JZ     DISP
	        CMP    AL,20H
	        JZ     EXIT
	DISP:   
	        MOV    DX,OFFSET TENH
	        MOV    AH,09H
	        INT    21H
	        MOV    AL,SECOND
	WAITCHA:
	        CMP    AL,SECOND
	        JZ     WAITCHA
	        JMP    FOREVER
	EXIT:   
	        CLI
	        CLD
	        POP    AX
	        OUT    21H,AL
	        MOV    AL,36H
	        OUT    43H,AL
	        MOV    AL,0
	        OUT    40H,AL
	        OUT    40H,AL
	
	        MOV    AX,0
	        MOV    ES,AX
	        MOV    DI,4*8
	        POP    AX
	        STOSW
	        POP    AX
	        STOSW
	        STI
	        RET
TIMER PROC FAR
	        PUSH   AX
	        DEC    COUNT
	        JNZ    L2
	        MOV    COUNT,100
	        INC    SECOND
	        CMP    SECOND,'9'
	        JLE    TIMEXT
	
	        MOV    SECOND,'0'
	        INC    TENS
	        CMP    TENS,'6'
	        JL     TIMEXT
	
	        MOV    TENS,'0'
	        INC    MINUTE
	        CMP    MINUTE,'9'
	        JLE    TIMEXT
	
	        MOV    MINUTE,'0'
	        INC    TENM
	        CMP    TENM,'6'
	        JL     TIMEXT
	
	        MOV    TENM,'0'
	        JMP    L3
	L2:     JMP    TIMEXT
	L3:     MOV    AL,HOUR
	        AND    AL,0FH
	        MOV    AH,TENH
	        AND    AH,0FH
	        MOV    CL,4
	        ROR    AH,CL
	        OR     AL,AH
	        ADD    AL,1
	        DAA
	        CMP    AL,24
	        JL     L1
	
	        MOV    TENH,'0'
	        MOV    HOUR,'0'
	        JMP    TIMEXT
	L1:     MOV    AH,AL
	        AND    AL,0FH
	        OR     AL,30H
	        MOV    HOUR,AL
	
	        MOV    CL,4
	        ROR    AH,CL
	        AND    AH,0FH
	        OR     AH,30H
	
	        MOV    TENH,AH
	
	TIMEXT: 
	        MOV    AL,20H
	        OUT    20H,AL
	        POP    AX
	        IRET
TIMER ENDP
START ENDP
CODE ENDS
	END START

