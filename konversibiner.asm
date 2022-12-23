title BinaryConverter
.model small 
.stack 100h
.data
	msg_input db "Masukkan bilangan desimal : ", "$"
	msg_output db "Format bilangan binernya adalah : ", "$"
	input1 dw ? ;input 1
	input2 dw ? ;input banyak
.code

main proc
	
	mov ax, @data
	mov ds,ax
	
	call input ;memanggil fungsi input
	
	mov ax, 4c00h
	int 21h
	
main endp
	
input proc
	lea dx, msg_input ;cetak pesan input
	mov ah, 09h
	int 21h
		
	mov cl, 0 ;inisialisasi counter untuk loop1
	mov input2, 0 ;inisialisasi variabel
		
	;loop untuk lebih dari 5 input
	loop1:
		mov ah, 01h
		int 21h
			
		mov ah, 0 ;kosongkan register ah
			
		cmp al, 13 ;jika enter ditekan maka lompat ke endloop
		je endloop
			
		sub al, 48 ;konversi nilai
		mov input1, ax ;memindahkan input yang dimasukkan ke input variabel
			
		mov ax, input2 ;gandakan input sebelumnya dengan 10 dan tambahkan input baru
		mov bx, 10
		mul bx
		add ax, input1
			
		mov input2, ax ;nilai akhir disimpan
			
		inc cl ;increment counter
		xor ax, ax ;kosongkan register ax
			
	cmp cl, 4 ;berhenti setelah mendapatkan 5 input
	jle loop1
		
	xor bx,bx ;kosongkan register bx
	xor ax,ax;kosongkan register ax
		
	endloop:
		clc ;kosongkan carry flag
		mov cl, 0 ;reset counter
		mov bl, 4 ;mengisi register bl dengan 4
			
		mov dl,0ah ;cetak baris baru
		mov ah, 02h
		int 21h
			
		lea dx, msg_output ;cetak pesan output
		mov ah, 09h
		int 21h
			
		loop2:
			cmp cl, bl ;jika penghitung tidak sama dengan bl (yang nilai awalnya 3) lompat ke nospace 
			jne nospace
				
			;jika kita membutuhkan spasi tidak langsung lompat ke nospace, dan mencetak baris dibawah
				
			mov dl, ' ' ;cetak spasi
			mov ah, 02h
			int 21h
				
			add bl, 4 ;tambahkan 4 ke register bl
				
			nospace: 
				
				shl input2, 1 ;bit bergeser ke kiri untuk menempatkan bit paling sesuai ke carriage flag
				
				jc else_block ;jc bernilai benar jika cf = 1
					mov dl, '0' ;jika jc bernilai salah (tidak lompat ke else block) cetak 0
					mov ah, 02h
					int 21h
					jmp cont ;akhiri perkondisian
				else_block: ;jika jc bernilai benar cf = 1
					mov dl, '1' ;cetak 1
					mov ah, 02h
					int 21h
				
				
			cont:
			clc ;kosongkan carry flag
		
		inc cl ;tambahkan counter dengan 1
		cmp cl, 15 ;setelah 16 kali loop, loop akan berhenti
		jle loop2
ret
input endp ;akhiri fungsi input
	
end main