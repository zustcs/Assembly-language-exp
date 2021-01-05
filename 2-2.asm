DATAS SEGMENT
    MSG_START db 'Interrupt service routine '
    MSG_N     db ?
    MSG_END   db ' is running...',0AH,0DH,'$'
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    ;�����ж�ʸ����
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
    ;��ʼ��DATA�λ�ַ
    MOV AX,DATAS
    MOV DS,AX
    ;��ʼ����
KEY_INPUT:
    MOV AH,0
    INT 16H
    CMP AL,'1'
    JZ  KEY_1
    CMP AL,'2'
    JZ  KEY_2
    CMP AL,'3'
    JZ  KEY_3
    ;����ESC����
    CMP AL,1BH
    JZ  EXIT
    ;������123�ص���ͷ
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
;�ж�71H
INT_KEY_1 PROC
    MOV AL,'1'
    PUSH AX
    CALL PRINT
    IRET
INT_KEY_1 ENDP
;�ж�72H
INT_KEY_2 PROC
    MOV AL,'2'
    PUSH AX
    CALL PRINT
    IRET
INT_KEY_2 ENDP
;�ж�73H
INT_KEY_3 PROC
    MOV AL,'3'
    PUSH AX
    CALL PRINT
    IRET
INT_KEY_3 ENDP
;��ӡ��Ϣ
;����:ջ��ѹ�����N
PRINT PROC USES AX DX BP DS
    ;��ʼ���λ�ַ
    MOV AX,DATAS
    MOV DS,AX
    ;ȡջ��
    MOV BP,SP
    ;��ò���
    ;IP:ƫ��+2,4���Ĵ���+4*2
    MOV AX,[BP+2+4*2]
    MOV MSG_N,AL
    LEA DX,MSG_START
    MOV AH,09H
    INT 21H
    RET 2
PRINT ENDP
CODES ENDS
    END START


