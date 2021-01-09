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
    ;初始化 切换到用户调用模式
    CALL SWITCH_INT9
KEY_IN:
    MOV AH,0
    ;利用 INT 16 等待键盘调用
    INT 16H
    CMP I9_MODE,0
    JNZ KEY_IN
    ;处理系统调用
    ;输入ESC
    CMP AL,1BH
    JNZ OUTPUT
    ;切换模式
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
    ;初始化段基址
    MOV AX,DATAS
    MOV DS,AX
    MOV AH,09H
    INT 21H
    RET
DISP_TXT ENDP

USER_INT PROC NEAR USES AX BX
    IN  AL,60H
    ;是否为通码
    TEST AL,80H
    ;为断码结束中断
    JNZ END_INT
    ;保存扫描码至栈
    PUSH AX
    IN  AL,61H
    ;设置应答位
    OR  AL,80H
    OUT 61H,AL
    AND AL,7FH
    ;复位应答位
    OUT 61H,AL
    ;从栈中恢复扫描码
    POP AX
    ;是否为ESC
    CMP AL,01
    JZ  SWITCH_INT
    ;扫描码转换
    LEA BX,SCAN_TB
    ;AL=[BX+AL]
    XLAT
    ;判断是否需要展示
    CMP AL,0
    JZ  END_INT
    CALL DISP_CHAR
    JMP END_INT
SWITCH_INT:
    CALL SWITCH_INT9
END_INT:
    CLI
    MOV AL,20H
    ;结束键盘中断 发送一次EOI命令（键盘IR1是主片）
    OUT 20H,AL
    IRET
USER_INT ENDP

SWITCH_INT9 PROC NEAR USES AX
    CMP INT9_IP,0
    JNZ LOAD
    ;保存原 INT 9 中断
    MOV AX,3509H
    INT 21H
    MOV INT9_IP,BX
    MOV INT9_CS,ES
    ;设置新 INT 9
LOAD:
    ;禁止中断发生 防止替换 INT 9 出错
    CLI
    CMP I9_MODE,0
    JZ  MODE1
    ;系统键盘处理程序
MODE0:
    MOV I9_MODE,0
    LEA DX,MSG_SWITCH0
    CALL DISP_TXT
    PUSH DS
    MOV DX,INT9_IP
    MOV AX,INT9_CS
    MOV DS,AX
    JMP DO_SWITCH
    ;用户键盘处理程序
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
    ;允许中断发生
    STI
    RET
SWITCH_INT9 ENDP
CODES ENDS
    END START




