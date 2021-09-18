;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;自动化1805班  段钧韬  U201814357
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
assume cs:codeseg, ds:dataseg, ss:stackseg
dataseg segment
	show      DB 9 dup(0AH,0DH)
	          DB 20 DUP(' '),'********************MENU*******************',0AH,0DH
	          DB 20 DUP(' '),'**    1: Play: Ode to Joy                **',0AH,0DH
	          DB 20 DUP(' '),'**    2: Play: Auld Lang Syne            **',0AH,0DH
	          DB 20 DUP(' '),'**    q: exit                            **',0AH,0DH
              DB 20 DUP(' '),'**    p: pause                           **',0AH,0DH
              DB 20 DUP(' '),'**    c: continue                        **',0AH,0DH
	          DB 10 dup(0AH,0DH),'$'
	mus_freq1 dw 330,330,349,392
	          dw 392,349,330,294
	          dw 262,262,294,330
	          dw 330,294,294
	          dw 330,330,349,392
	          dw 392,349,330,294
	          dw 262,262,294,330
	          dw 294,262,262
	          dw 294,294,330,262
	          dw 294,330,349,330,262
	          dw 294,330,349,330,294
	          dw 262,294,196,330
	          dw 330,330,349,392
	          dw 392,349,330,349,294
	          dw 262,262,294,330
	          dw 294,262,262,-1
	mus_time1 dw 3 dup(25,25,25,25),37,12,50
	          dw 3 dup(25,25,25,25),37,12,50,25,25,25,25
	          dw 2 dup(25,12,12,25,25)
	          dw 2 dup(25,25,25,25)
	          dw 25,25,25,12,12,25,25,25,25,37,12,25
    mus_info1 DB 10 dup(0AH,0DH)
              db 0AH,0DH,28 DUP(' '),'**Playing: Ode to Joy**',0AH,0DH
              db 28 DUP(' '),'**p: pause           **',0AH,0DH
              db 28 DUP(' '),'**c: continue        **',0AH,0DH
              db 28 DUP(' '),'**q: exit            **',0AH,0DH
              DB 11 dup(0AH,0DH),'$'
	mus_freq2 dw 196
              dw 262,262
              dw 262,330
              dw 294,262
              dw 294,330
              dw 262,262
              dw 330,392
              dw 440
              dw 440,21000,440
              dw 392,330
              dw 330,262
              dw 294,262
              dw 294,330
              dw 262,220
              dw 220,196
              dw 262
              dw 262,21000,440
              dw 392,330
              dw 330,262
              dw 294,262
              dw 294,440
              dw 392,330
              dw 330,392
              dw 440
              dw 440,21000,524
              dw 392,330
              dw 330,262
              dw 294,262
              dw 294,330
              dw 262,220
              dw 220,196
              dw 262
              dw 262,21000,-1
	mus_time2 dw 25
              dw 6 dup(50,25),75,25,25,25
              dw 6 dup(50,25),75,25,25,25
              dw 6 dup(50,25),75,25,25,25
              dw 6 dup(50,25),75,25,25,25
    mus_info2 DB 10 dup(0AH,0DH)
              db 0AH,0DH,26 DUP(' '),'**Playing: Auld Lang Syne**',0AH,0DH
              db 26 DUP(' '),'**p: pause               **',0AH,0DH
              db 26 DUP(' '),'**c: continue            **',0AH,0DH
              db 26 DUP(' '),'**q: exit                **',0AH,0DH
              DB 11 dup(0AH,0DH),'$'
dataseg ends

stackseg segment
	         db 100h dup (0)
stackseg ends

codeseg segment
	start:  
	        mov  ax, stackseg
	        mov  ss, ax
	        mov  sp, 100h

	        mov  ax, dataseg
	        mov  ds, ax
	showsth:
	        lea  dx,show
	        mov  ah,09h
	        int  21h
	        MOV  AH,01H
	        INT  21H          	;输入字符
	        cmp  al,'1'
	        jz   play1
	        cmp  al,'2'
	        jz   play2
	        cmp  al,'q'
	        jz   exit
	        jmp  showsth
	play1:                    	;欢乐颂
	        lea  si,mus_freq1
	        lea  di,mus_time1
            lea  dx,mus_info1
	        mov  ah,09h
	        int  21h
	        jmp  play
	play2:                    	;新年好
	        lea  si,mus_freq2
	        lea  di,mus_time2
            lea  dx,mus_info2
	        mov  ah,09h
	        int  21h
	play:   
	        mov  dx, [si]
	        cmp  dx, -1
	        je   showsth
	        call sound
	        add  si, 2
	        add  di, 2
	        jmp  KEY_C

	exit:   
	        mov  ax, 4c00h
	        int  21h

	KEY_C:  
	        PUSH AX
	        MOV  AH,0BH       	;检验键盘状态
	        INT  21H
	        CMP  AL,0FFH      	;有输入时
	        jz   OK
	        JMP  OUT_K

	OK:     
	        MOV  AH,01H
	        INT  21H
	        cmp  al,'p'
	        jz   pause
	        cmp  al,'q'
	        jz   exit
	        jmp  OUT_K

	pause:  
	        MOV  AH,0BH       	;检验键盘状态
	        INT  21H
	        CMP  AL,0FFH      	;无输入时
	        jz   OK_p
	        jmp  pause

	OK_p:   
	        MOV  AH,01H
	        INT  21H
	        cmp  al,'c'
	        jz   OUT_K
	        cmp  al,'q'
	        jz   exit
	        jmp  pause


	OUT_K:  
	        pop  ax
	        jmp  play
	;演奏一个音符
	;入口参数：si - 要演奏的音符的频率的地址
	;         di - 要演奏的音符的音长的地址
	sound:  
	        push ax
	        push dx
	        push cx

	;8253 芯片(定时/计数器)的设置
	        mov  al,0b6h      	;8253初始化
	        out  43h,al       	;43H是8253芯片控制口的端口地址
	        mov  dx,12h
	        mov  ax,34dch
	        div  word ptr [si]	;计算分频值,赋给ax。[si]中存放声音的频率值。
	        out  42h, al      	;先送低8位到计数器，42h是8253芯片通道2的端口地址
	        mov  al, ah
	        out  42h, al      	;后送高8位计数器

	;设置8255芯片, 控制扬声器的开/关
	        in   al,61h       	;读取8255 B端口原值
	        mov  ah,al        	;保存原值
	        or   al,3         	;使低两位置1，以便打开开关
	        out  61h,al       	;开扬声器, 发声

	        mov  dx, [di]     	;保持[di]时长
	wait1:  
	        mov  cx, 28000
	delay:  
	        nop
	        loop delay
	        dec  dx
	        jnz  wait1

	        mov  al, ah       	;恢复扬声器端口原值
	        out  61h, al

	        pop  cx
	        pop  dx
	        pop  ax
	        ret

codeseg ends
end start