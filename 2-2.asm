DATAS SEGMENT
    MSG_START db 'Interrupt service routine '
    MSG_N     db ?
    MSG_END   db ' is running...',0AH,0DH,'$'
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    ;建立中断矢量表
    MOV AH,25H
    MOV AL,71H
    MOV DX,SEG INT_KEY_1
    MOV DS,DX
    MOV DX,OFFSET INT_KEY_1
    INT 21H
    MOV AL,72H
    MOV DX,SEG INT_KEY_2
    MOV DS,DX
    MOV DX,OFFSET INT_KEY_2
    INT 21H
    MOV AL,73H
    MOV DX,SEG INT_KEY_3
    MOV DS,DX
    MOV DX,OFFSET INT_KEY_3
    INT 21H
    ;初始化DATA段基址
    MOV AX,DATAS
    MOV DS,AX
    ;开始运行
KEY_INPUT:
    MOV AH,0
    INT 16H
    CMP AL,'1'
    JZ  KEY_1
    CMP AL,'2'
    JZ  KEY_2
    CMP AL,'3'
    JZ  KEY_3
    ;输入ESC结束
    CMP AL,1BH
    JZ  EXIT
    ;非数字123回到开头
    JMP KEY_INPUT
EXIT:
    MOV AH,4CH
    INT 21H
KEY_1:
    INT 71H
    JMP KEY_INPUT
KEY_2:
    INT 72H
    JMP KEY_INPUT
KEY_3:
    INT 73H
    JMP KEY_INPUT
;中断71H
INT_KEY_1 PROC
    MOV AL,'1'
    PUSH AX
    CALL PRINT
    IRET
INT_KEY_1 ENDP
;中断72H
INT_KEY_2 PROC
    MOV AL,'2'
    PUSH AX
    CALL PRINT
    IRET
INT_KEY_2 ENDP
;中断73H
INT_KEY_3 PROC
    MOV AL,'3'
    PUSH AX
    CALL PRINT
    IRET
INT_KEY_3 ENDP
;打印信息
;输入:栈顶压入参数N
PRINT PROC USES AX DX BP DS
    ;初始化段基址
    MOV AX,DATAS
    MOV DS,AX
    ;取栈顶
    MOV BP,SP
    ;获得参数
    ;IP:偏移+2,4个寄存器+4*2
    MOV AX,[BP+2+4*2]
    MOV MSG_N,AL
    LEA DX,MSG_START
    MOV AH,09H
    INT 21H
    RET 2
PRINT ENDP
CODES ENDS
    END START


