DATAS SEGMENT
    I9_MODE db 0
    INT9_IP dw 0
    INT9_CS dw 0
	SCAN_TB db 0,0,'1234567890-=',08h,0
	        db 'QWERTYUIOP[]',0DH,0
	        db 'ASDFGHJKL;',0,0,0,0
	        db 'ZXCVBNM,./',0,0,0,' '
	        db 13 dup(0)
	        db '789-456+1230.'
	MSG_SWITCH0 db 'Switch to system mode',0AH,0DH,'$'
	MSG_SWITCH1 db 'Switch to user mode',0AH,0DH,'$'
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;��ʼ�� �л����û�����ģʽ
    CALL SWITCH_INT9
KEY_IN:
    MOV AH,0
    ;���� INT 16 �ȴ����̵���
    INT 16H
    CMP I9_MODE,0
    JNZ KEY_IN
    ;����ϵͳ����
    ;����ESC
    CMP AL,1BH
    JNZ OUTPUT
    ;�л�ģʽ
    CALL SWITCH_INT9
    JMP KEY_IN
OUTPUT:
    CALL DISP_CHAR
    JMP KEY_IN

DISP_CHAR PROC NEAR
    MOV    AH,14
    INT    10H
    MOV    AL,0DH
    INT    10H
    MOV    AL,0AH
    INT    10H
    RET
DISP_CHAR ENDP

DISP_TXT PROC NEAR
    ;��ʼ���λ�ַ
    MOV AX,DATAS
    MOV DS,AX
    MOV AH,09H
    INT 21H
    RET
DISP_TXT ENDP

USER_INT PROC NEAR USES AX BX
    IN  AL,60H
    ;�Ƿ�Ϊͨ��
    TEST AL,80H
    ;Ϊ��������ж�
    JNZ END_INT
    ;����ɨ������ջ
    PUSH AX
    IN  AL,61H
    ;����Ӧ��λ
    OR  AL,80H
    OUT 61H,AL
    AND AL,7FH
    ;��λӦ��λ
    OUT 61H,AL
    ;��ջ�лָ�ɨ����
    POP AX
    ;�Ƿ�ΪESC
    CMP AL,01
    JZ  SWITCH_INT
    ;ɨ����ת��
    LEA BX,SCAN_TB
    ;AL=[BX+AL]
    XLAT
    ;�ж��Ƿ���Ҫչʾ
    CMP AL,0
    JZ  END_INT
    CALL DISP_CHAR
    JMP END_INT
SWITCH_INT:
    CALL SWITCH_INT9
END_INT:
    CLI
    MOV AL,20H
    ;���������ж� ����һ��EOI�������IR1����Ƭ��
    OUT 20H,AL
    IRET
USER_INT ENDP

SWITCH_INT9 PROC NEAR USES AX
    CMP INT9_IP,0
    JNZ LOAD
    ;����ԭ INT 9 �ж�
    MOV AX,3509H
    INT 21H
    MOV INT9_IP,BX
    MOV INT9_CS,ES
    ;������ INT 9
LOAD:
    ;��ֹ�жϷ��� ��ֹ�滻 INT 9 ����
    CLI
    CMP I9_MODE,0
    JZ  MODE1
    ;ϵͳ���̴������
MODE0:
    MOV I9_MODE,0
    LEA DX,MSG_SWITCH0
    CALL DISP_TXT
    PUSH DS
    MOV DX,INT9_IP
    MOV AX,INT9_CS
    MOV DS,AX
    JMP DO_SWITCH
    ;�û����̴������
MODE1:
    MOV I9_MODE,1
    LEA DX,MSG_SWITCH1
    CALL DISP_TXT
    PUSH DS
    MOV DX,OFFSET USER_INT
    MOV AX,SEG USER_INT
    MOV DS,AX
DO_SWITCH:
    MOV AX,2509H
    INT 21H
    POP DS
    ;�����жϷ���
    STI
    RET
SWITCH_INT9 ENDP
CODES ENDS
    END START




