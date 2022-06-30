.data
nome:	.asciiz "D:/SistInf/Org/teste.txt"
buffer:	.space	4084
Palavra:.space 100
Escreva_char: .asciiz "Digite uma letra minuscula?"

.text


.globl main

init:
	j main
	
finit:
            move  $a0, $v0      # o valor de retorno de main é colocado em $a0
            li    $v0, 17       # serviço 17: termina o programa
            syscall 
	
abrir_arquivo:
	li $v0, 13
	la $a0, nome
	li $a1, 0
	syscall 
	move $t0,$v0
	
	li $v0,14
	move $a0, $t0
	la $a1, buffer
	la $a2, 4084
	syscall
	jr $ra
	
retorna_posicao_do_sorteador:
	addi  $sp, $sp, -4
	sw $a0,0($sp) 
	lw $t0, 0($sp)
	addi $t1,$zero,0 # var i
	addi $t2,$zero,0 # endline contador
	j if_endline
	
incrementa_i:
	addi $t1,$t1,1
	
if_endline:
	li $t4,'\n'
	lb $t5,buffer($t1)
	bne $t4,$t5,if_endline_false
	
if_endline_true:
	addi $t2,$t2,1
	j while_condicao

if_endline_false:
	nop
	
if_endlineCont_Sort:
	beq $t0,$t2,fim_retorna_posicao_sorteador

while_condicao:
	addi $t3, $zero,4084
	bne $t1,$t3,incrementa_i
	
fim_retorna_posicao_sorteador:
	sw $t1,0($sp)
	lw   $v0, 0($sp)    # valor de retorno é igual a menor
        addi $sp, $sp, 4    # restauramos a pilha
        jr   $ra            # retorna ao procedimento chamador


preencher_palavra:
	addi $sp, $sp, -4
	sw $a0,0($sp) 
	lw $t0, 0($sp) #posi��o buffer
	li $t1, 0 #var i

verifica_endline_string:
	la $t2, '\r'
	lb $t3, buffer($t0)
	beq $t2,$t3, fim_preenche
	
salva_na_palavra:
	sb $t3,Palavra($t1)
	addi $t0,$t0,1
	addi $t1,$t1,1
	j verifica_endline_string
		
	
fim_preenche:
	sw $t1,0($sp)
	lw   $v0, 0($sp)    # valor de retorno é igual a menor
        addi $sp, $sp, 4    # restauramos a pilha
        jr   $ra
			

ler_caracter:
	addi  $sp, $sp, -4

loop_char:
	li $t0, '\n'
	li $v0, 11
	la $a0, 0($t0)
	syscall
pede_char:
	li $v0, 4
	la $a0, Escreva_char
	syscall
	li   $v0, 12       
  	syscall           
  	add $a0, $v0, $zero
  	sw $a0, 0($sp)
  	lw $t1, 0($sp)

char_valido:
	li $t2,123
	li $t3,96
	bge $t1,$t2,loop_char
	ble $t1,$t3,loop_char

fim_ler_caracter:
	lw   $v0, 0($sp)   
        addi $sp, $sp, 4   
        jr   $ra
        
verifica_char_na_Palavra:

	addi  $sp, $sp, -8
	sw $a0,0($sp) 
	lw $t0, 0($sp) # tamanho palavra
	sw $a1,4($sp) 
	lw $t1, 4($sp) # char recebido 
	xor $t2,$t2,$t2 # var i
	xor $t3,$t3,$t3 # contador de vezes na palavra
	j percorre_palavra

incrementa_var_i:
	addi $t2,$t2,1
		
percorre_palavra:	
	beq $t0,$t2,fim_verifica_char_na_Palavra
	lb $t5,Palavra($t2)
	beq $t1,$t5,incrementa_contador
	j incrementa_var_i
		
incrementa_contador:
	addi $t3,$t3,1
	j incrementa_var_i

fim_verifica_char_na_Palavra:
	sw $t3,0($sp) 
	lw $v0, 0($sp)
	addi  $sp, $sp, 8
	jr $ra


main:
	addi $sp, $sp, -4 
	#jal ler_caracter
	#sw $v0,0($sp)
	#li $v0, 11
	#lw $a0,0($sp)
	#syscall
	jal abrir_arquivo
	li $a0,8
	jal retorna_posicao_do_sorteador
	sw $v0,0($sp)
	lw $a0, 0($sp)
	jal preencher_palavra
	sw $v0,0($sp)
	li $v0, 1
	lw $a0, 0($sp)
	syscall
	li $v0, 4
	la $a0, Palavra
	syscall
	lw $a0,0($sp)
	li $a1, 'z'
	jal verifica_char_na_Palavra
	sw $v0,0($sp)
	li $v0, 1
	lw $a0, 0($sp)
	syscall
	
