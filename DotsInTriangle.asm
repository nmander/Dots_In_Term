;----------------------------------------------- 
;- Niklas Andersson 
;- CIS 333 - Assignment 3 
;- 10.03.16
;- Scott James 
;----------------------------------------------- 
 
            .MODEL SMALL 
            
            .STACK 100h
            
MAX_TERMS   EQU 26          ;CONST
                          
                          
            ;Data declaration 
             
            .DATA 
                                        

valueN      DB  1
                                     
             
            .CODE 
            
             
main:       mov ax, @DATA 
            mov ds, ax      ;initalize data segment      
                                
            call clrScreen  ;clear emulator screen


loop:       call formula    ;calculate num of dots in term
            
            call convert    ;convert to hex value and print         
            
            inc valueN      ;valueN + 1                 
            
            cmp valueN, MAX_TERMS   ;loop til 25 terms 
            jz exit
            
            mov ah, 02h     ;print comma between each term
            mov dl, ','
            int 21h
            jmp loop                                                                                   
                                
exit:       ;End program 
             
            mov ax, 4C00h 
            int 21h 



;-----------PROCEDURES ------------  

clrScreen   PROC near
             
            mov ah, 06h     ;clear screen call 
            mov bh, 07h 
            mov cx, 0000h   ;row 0, col 0 
            mov dh, 24d     ;row 24 
            mov dl, 79d     ;row 79  
            int 10h 
            ret
            
clrScreen   ENDP

;----------------------------------             

formula     PROC near       ;n(n+1)/2     result in ax when return
                                  
            mov al, valueN  ;al = n            
            mov bl, al      ;bl = n           
            inc bl          ;bl = n+1            
            mul bl          ;al * bl = n(n+1) -> ax            
            shr ax, 1       ;ax / 2  = num of dots
            ret   
            
formula     ENDP

;---------------------------------

convert     PROC near       ;dec to hex
            
            mov ch, 00h     ;ch boolean register
            mov bx, 0100h   ;div 256 
            mov dx, 0000h   ;clear upper half of 32-bit DX:AX
            div bx          ;DX:AX / 256
            
            mov cl, dl      ;copy dl(Remainder) to cl
           
;100            
chkDigit_1: cmp al, 09h     ;if al is > 9 then add 07h
            jbe digit_1                 
            
            add al, 07h     ;skips from 9 to capital A in ascii
            
digit_1:    add al, 30h     ;add 30h to digit_1 for ascii representation 
            
            cmp al, 30h     ;leading 0? don't print
            je  divby16
            
            mov ah, 02h     ;print digit_1
            mov dl, al
            int 21h
            
            mov ch, 01h     ;printed first character (true)

divby16:    mov ah, 00h     ;clear upper half of ax register    
            mov al, cl      ;copy cl(Remainder) to al                       
                      
            mov bx, 0010h   ;div 16                    
            mov dx, 0000h   ;clear upper half of 32-bit DX:AX 
            div bx          ;DX:AX / 16
            
            mov cl, dl      ;copy dl(Remainder) to cl
            
;020 
chkDigit_2: cmp al, 09h     ;if al is > 9 then add 07h
            jbe digit_2
            
            add al, 07h     ;skips from 9 to capital A in ascii
            
digit_2:    add al, 30h     ;add 30h to digit_2 for ascii representation
            
            cmp ch, 01h     ;if digit_1 printed, always print digit_2
            je printDigit_2
            
            cmp al, 30h     ;leading 0? don't print
            je chkDigit_3

printDigit_2:
            mov ah, 02h     ;print digit_2
            mov dl, al
            int 21h
            
;003               
chkDigit_3: cmp cl, 09h     ;if cl is > 9 then add 07h
            jbe digit_3
          
            add cl, 07h     ;skips from 9 to capital A in ascii               
            
digit_3:    add cl, 30h     ;add 30h to digit_3 for ascii representation

            mov ah, 02h     ;print digit_3
            mov dl, cl
            int 21h

end_convert:ret

convert     ENDP

;----------------------------------    

            END main        