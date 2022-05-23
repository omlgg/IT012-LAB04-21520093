		.data
array:		.space 400
nhaplai:	.asciiz "Vui long nhap lai:\n"
nhapi:		.asciiz "Nhap phan tu thu "
nhapi_close:	.asciiz "(so nguyen duong) :\n"
tb1:		.asciiz "Nhap do dai mang n (1 <= n <= 100): \n"
tb2:		.asciiz "Nhap cac phan tu: \n"
tb3:		.asciiz "Cac phan tu cua mang: \n"
outputtong:	.asciiz	"\nTong cac phan tu: "
outputle:	.asciiz	"\nSo phan tu le: "
outputchan:	.asciiz "\nSo phan tu chan: "
outputmin:	.asciiz "\nPhan tu nho nhat: "
outputmax:	.asciiz "\nPhan tu lon nhat: "
		.text
main:


input_n:#n la so phan tu cua mang
	#nhap n:
	li 	$v0, 4
	la 	$a0, tb1
	syscall #thong bao nhap n
	li 	$v0, 5
	syscall #nhap so n
	slti 	$t0, $v0, 1 #$t0 = 1 neu n <= 0
	li 	$t2, 100
	slt 	$t1, $t2, $v0
	bne 	$t0, $zero, input_n #lap lai neu n <= 0
	bne	$t1, $zero, input_n #lap lai neu n > 100
end_input_n:
	
	
	
	add 	$s0, $zero, $v0	#$s0 = n
	la	$s1, array	#$s1: dia chi array
	
	
	li	$v0, 4
	la 	$a0, tb2
	syscall 		#thong bao nhap cac phan tu
	add 	$t3, $zero, $s1 #luu array address vao t3
	
	
	li	$t0, 0 #khoi tao bien dem
inputloop:	#nhap cac phan tu trong mang
	addi 	$t0, $t0, 1 #t0 = t0 + 1
	
	
	li	$v0, 4
	la	$a0, nhapi
	syscall
	
	
	li 	$v0, 1
	add	$a0, $zero, $t0
	syscall
	
	
	li	$v0, 4
	la	$a0, nhapi_close
	syscall
	#thong bao nhap phan tu thu i
	
	checkpos: #kiem tra phan tu duong
		li	$v0, 5
		syscall
		add 	$t1, $zero, $v0
		slti	$t2, $t1, 1 # $t2 = 0 neu $t1 > 0
		beq	$t2, $zero, endcheckpos #t2 = 0 -> $t1 > 0 -> ko nhap lai
		li 	$v0, 4
		la 	$a0, nhaplai
		syscall #thong bao nhap lai
		j checkpos
	endcheckpos:	
	sw	$v0, 0($t3)
	
	addi	$t3, $t3, 4 #t3 = t3 + 4 (next word)
	bne	$t0, $s0, inputloop
endinputloop:

	
	li	$s2, 0		#$s2: tong cac phan tu
	li 	$s3, 0 		#$s3: dem cac phan tu le
	li 	$s4, 0		#$s4: dem cac phan tu chan
	lw	$s5, 0($s1)	#$s5: min cac phan tu
	lw 	$s6, 0($s1)	#$s6: max cac phan tu
	li 	$t0, 0		#khoi tao bien dem $t0
	la	$t1, array	#luu array address vao $t1
checkloop:	#tinh toan cac yeu cau cua de bai
	addi 	$t0, $t0, 1
	
	lw	$t2, 0($t1) 	#$t2 luu gia phan tu thu $t0
	add	$s2, $s2, $t2	# cong gia tri phan tu vao tong
	
	checkodd:#kiem tra phan tu la so le
		andi	$t3, $t2, 1	#$t3 = 1 neu $t2 la so le
		add	$s3, $s3, $t3	#so phan tu le tang them 1
		bne 	$t3, $zero, endcheckodd #$t3 = 1 => nhay den end phan checkodd
		addi	$s4, $s4, 1	#tang so phan tu chan
	endcheckodd:
	
	
	updatemin:
		slt 	$t3, $t2, $s5			#$t3 = 1 neu $t2 < $s5
		beq	$t3, $zero, endupdatemin	#$t3 = 0 -> end phan update min
		add 	$s5, $zero, $t2			#cap nhat $s5 := $t2
	endupdatemin:
		
	updatemax:
		slt	$t3, $s6, $t2			#$t3 = 1 neu $s6 < $t2
		beq	$t3, $zero, endupdatemax	#$t3 = 0 -> end phan update max
		add	$s6, $zero, $t2			#cap nhat $s6 := $t2
	endupdatemax: 	
	
	addi 	$t1, $t1, 4		#$t1 = $t1 + 4 (next word)
	bne 	$t0, $s0, checkloop	#dung vong lap neu $t0 = $s0
endcheckloop:
	
output:
	la 	$a0, outputtong
	li	$v0, 4
	syscall #thong bao xuat tong
	
	li	$v0, 1
	add	$a0, $zero, $s2
	syscall #xuat tong
	
	la 	$a0, outputle
	li	$v0, 4
	syscall #thong bao xuat so phan tu le
	
	li	$v0, 1
	add	$a0, $zero, $s3
	syscall #xuat so phan tu le
	
	la 	$a0, outputchan
	li	$v0, 4
	syscall #thong bao xuat so phan tu chan
	
	li	$v0, 1
	add	$a0, $zero, $s4
	syscall #xuat so phan tu chan
	
	la 	$a0, outputmin
	li	$v0, 4
	syscall #thong bao xuat phan tu nho nhat
	
	li	$v0, 1
	add	$a0, $zero, $s5
	syscall #xuat phan tu nho nhat
	
	la 	$a0, outputmax
	li	$v0, 4
	syscall #thong bao xuat phan tu lon nhat
	
	li	$v0, 1
	add	$a0, $zero, $s6
	syscall #xuat phan tu lon nhat
endoutput:
end:



	
	
		
