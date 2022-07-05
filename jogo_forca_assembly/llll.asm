.data
nome:		.asciiz "D:/SistInf/Org/teste.txt"
buffer:		.space	4084
Palavra:	.space	100
Chutes: 	.space 26
Escreva_char: 	.asciiz "Digite uma letra minuscula?"
Tentativas: 	.word 0
Numero_de_linhas: .word 50

mastro1:	.asciiz " _______    "
mastro2:	.asciiz "|/      |  "
campo_vazio:	.asciiz "|          "
cabeca1:	.asciiz "|      ( )  "
torso1:		.asciiz "|       |    "
torso2:		.asciiz "|      /|    "
torso3:		.asciiz "|      /|\\    "
perna1:		.asciiz "|      /    "
perna2:		.asciiz "|      / \\  "
base1:		.asciiz "|_____________"

.text


.globl main

init:
	j main
	
finit:
            move  $a0, $v0      # o valor de retorno de main Ã© colocado em $a0
            li    $v0, 17       # serviÃ§o 17: termina o programa
            syscall 

### Função Abrir Arquivo	
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
	
	li $v0,16
	move $a0, $t0
	syscall
	
	jr $ra
	
#retorna numero aleatorio
retorna_numero_aleatório:
	addi $sp,$sp,-8
	sw $ra, 4($sp)
	lw $a1, Numero_de_linhas
	li $a0, 0
	li $v0, 42
	syscall 
	sw $a0, 0($sp)
	lw $v0, 0($sp)
	lw $ra, 4($sp)
	addi $sp,$sp, 8
	jr $ra
	
### Função que vai retornar a posiçao da palavra sorteada no arquivo	
#int retorna_posicao_do_sorteado(int numero_sorteado){
#	int i = 0;
#	int cont_n = 0;
#	while(i < tamanho_buffer){
#		if(buffer[i] == '\n') cont_n ++; 
#		i++;
#		if(cont_n == numero_sorteado) break;
#	}
#	return i;
#}
retorna_posicao_do_sorteado:
	addi  $sp, $sp, -8
	sw $a0,0($sp)
	sw $ra,4($sp) 
	lw $t0, 0($sp) # recebe a quantidade de \n que precisa encontrar
	li $t1, 0 # var i contador 
	li $t2, 0 # endline contador 
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
	lw $ra, 4($sp)
	lw   $v0, 0($sp)    # valor de retorno Ã© igual a menor
        addi $sp, $sp, 8    # restauramos a pilha
        jr   $ra            # retorna ao procedimento chamador




#### Essa função vai receber um valor de posição dentro do buffer e preencher o space Palavra com os caracteres
#int preenche_palavra(int posicao_buffer){
#	int i = 0;
#	while(buffer[posicao_buffer]!='\r'){
#		Palavra[i] = buffer[posicao_buffer];
#		i++;
#		posicao_buffer ++;
#	}
#	return i;
#
preencher_palavra:
	addi $sp, $sp, -8
	sw $a0,0($sp) 
	sw $ra,4($sp)
	lw $t0, 0($sp) #posição buffer
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
	lw $ra, 4($sp)
	lw   $v0, 0($sp)    # valor de retorno Ã© igual a menor
        addi $sp, $sp, 8    # restauramos a pilha
        jr   $ra
			

##### Vai ler um char válido(minusculo) e retorná-lo
#char ler_caracter(){
#	char c;
#	while(1){
#		c = scanf();
#		if(!((int)c <= 96 || (int)c >= 123))
#			break;
#	}
#	return c;
#}
#
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
        
        
#### Vai verificar se na palavra existe o char x e retornar quantos valores desse há na palavra
#bool verifica_char_na_palavra(char letra,int tamanho_palavra)
#{
#	int i = 0;
#	while( i < tamanho_palavra){
#		if(letra == Palavra[i]) return 1;
#		i++;	
#	}
#	return 0;
#}
verifica_char_na_Palavra:
	addi  $sp, $sp, -12
	sw $a0,0($sp) 
	lw $t0, 0($sp) # tamanho palavra
	sw $a1,4($sp) 
	sw $ra,8($sp)
	lw $t1, 4($sp) # char recebido 
	xor $t2,$t2,$t2 # var i
	xor $t3,$t3,$t3 # contador de vezes na palavra
	j percorre_palavra

incrementa_var_i:
	addi $t2,$t2,1
		
percorre_palavra:	
	beq $t0,$t2,fim_verifica_char_na_Palavra
	lb $t4,Palavra($t2)
	beq $t1,$t4,incrementa_contador
	j incrementa_var_i
		
incrementa_contador:
	addi $t3,$t3,1

fim_verifica_char_na_Palavra:
	sw $t3,0($sp) 
	lw $ra, 8($sp)
	lw $v0, 0($sp)
	addi  $sp, $sp, 12
	jr $ra


# bool verifica_se_letra_ja_foi_usada(char letra){
#	int i = 0;
#	while( i < Tentativas ){
#		if(letra == Chutes[i]) return 1;
#		i++;
#	}
#	return 0;
#}

verifica_se_letra_ja_foi_usada:
	addi $sp,$sp, -8
	sw $a0,0($sp) 
	sw $ra,4($sp)
	lw $t0, 0($sp) # Salva o char que vem como argumento da função em $t0
	li $t1, 0 # Cria um booleano para dizer se encontrou ou não o caracter no array de chutes
	lw $t2, Tentativas # Pega a quantidade de tentativas, que é o mesmo que a quantidade de vezes válida que o player jogou
	li $t3, 0	# variável i contador que serve para percorrer o array de chutes
	
	j while_letra_ja_foi_usada
	
incrementa_i_while_letra_ja_foi_usada: # Vai incrementar em 1 o contador I 
	addi $t3,$t3,1 
	j while_letra_ja_foi_usada

encontrou_char_nos_chutes: # Caso seja encontrado o char no array de chutes, muda o valor do booleano para True
	addi $t1,$t1,1
	j fim_letra_ja_foi_usada

while_letra_ja_foi_usada: 
	beq $t3, $t2, fim_letra_ja_foi_usada # Verifica a condição do while onde i < tentativas
	lb $t4, Chutes($t3) # carrega o char do array de chutes
	beq $t0, $t4, encontrou_char_nos_chutes # Compara se o char recebido na função é igual a Chutes[i]
	j incrementa_i_while_letra_ja_foi_usada
	
fim_letra_ja_foi_usada: # Retorna o booleano para a função chamadora e remonta a pilha
	sw $t1,0($sp)
	lw $v0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	jr $ra

#verifica se todas as letras da palavra estão no chute
#bool verifica_se_ganhou(int tamanho_palavra){
#	int i = 0;
#	while(i < tamanho_palavra){
#		if(!verifica_se_letra_ja_foi_usada(Palavra[i])) return 0; 
#		i++;
#	}
#	return 1;
#	
verifica_se_ganhou:
	addi $sp,$sp,-16
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	lw $t0, 0($sp) # carrega tamanho_da palavra
	xor $t1,$t1,$t1 # contador i
	j while_verifica_se_ganhou

incrementa_i_verifica_se_ganhou:
	addi $t1,$t1,1

while_verifica_se_ganhou:
	beq $t1,$t0, fim_verifica_se_ganhou
	lb $a0, Palavra($t1)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	jal verifica_se_letra_ja_foi_usada
	sw $v0, 0($sp)
	lw $t2, 0($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)

compara_saida_verifica_se_ganhou:
	beqz $t2, fim_verifica_se_ganhou
	j incrementa_i_verifica_se_ganhou
	 
fim_verifica_se_ganhou:
	sw $t2,0($sp)
	lw $v0,0($sp)
	lw $ra, 4($sp)
	addi $sp,$sp,8
	jr $ra



printf:
	li $v0, 4
	syscall
	li $a0, '\n'
	li $v0, 11
	syscall
	jr $ra
		
#void printa_forca(int errors){
#	printf("  _______       \n");
#	printf(" |/      |      \n");
#	printf(" |      %c  \n", (erros>=5?'(':' '));
#	printf(" |    %c%c%c  \n", (erros>=3?'\\':' '), (erros>=4?'|':' '), (erros>=3?'/': ' '));
#	printf(" |     $c %c      \n", (erros>=2?'|':' '),erros>=1?'|':' '));
#	printf(" |          \n");
#	printf("_|___           \n");
#}
#
#



printa_forca:
	addi $sp,$sp,-8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	lw $t0, 4($sp) # vidas
mastro:
	la $a0, mastro1
	jal printf
	la $a0, mastro2 
	jal printf

cabeca:
	la $a0, campo_vazio 
	li $t1, 5
	bgt $t0, $t1, printa_cabeca
	la $a0, cabeca1
printa_cabeca:
	jal printf
torso:
	la $a0, campo_vazio 
	li $t1, 4
	bgt $t0, $t1, printa_torso
	la $a0, torso1 
	li $t1, 3
	bgt $t0, $t1, printa_torso
	la $a0, torso2
	li $t1, 2
	bgt $t0, $t1, printa_torso
	la $a0, torso3
printa_torso:
	jal printf
pernas:
	la $a0, campo_vazio 
	li $t1, 1
	bgt $t0, $t1, printa_pernas
	la $a0, perna1
	li $t1, 0
	bgt $t0, $t1, printa_pernas
	la $a0, perna2
printa_pernas:
	jal printf
base:
	la $a0, campo_vazio
	jal printf
	la $a0, base1
	jal printf
fim_print_forca:
	lw $ra,0($sp)
	addi $sp,$sp,8
	jr $ra

#void printa_palavra(int tamanho_palavra){
#	int i = 0;
#	while(i<tamanho_palavra){
#		int j = 0;
#		char caracter = '_';
#		while(j < Tentativas){
#			if(Palavra[i] == Chutes[j])
#			{
#				caracter = Palavra[i];
#				break;
#			}
#			j++;
#		}
#		printf("%c",caracter);
#		i++;
#	}
#	printf("\n");
#}
printa_palavra:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $a0,4($sp)
	lw $t0, 4($sp)
	li $t1, 0 # Contador i = 0
	j while_percorre_palavra_printa_palavra

incrementa_i_printa_palavra:
	addi $t1, $t1, 1
	j while_percorre_palavra_printa_palavra
	
incrementa_j_printa_palavra:
	addi $t3,$t3, 1
	j while_percorre_chutes_printa_palavra

while_percorre_palavra_printa_palavra:
	beq $t1, $t0, fim_printa_palavra
	li $t2, '_'
	li $t3, 0

while_percorre_chutes_printa_palavra:
	lw $t4,Tentativas
	beq $t3,$t4, printa_caracter_printa_palavra
	lb $t5, Palavra($t1)
	lb $t6, Chutes($t3)
	beq $t5,$t6,atribui_valor_em_caracter_printa_palavra
	j incrementa_j_printa_palavra

atribui_valor_em_caracter_printa_palavra:
	move $t2, $t5

printa_caracter_printa_palavra:
	li $v0, 11
	add $a0, $zero, $t2
	syscall
	j incrementa_i_printa_palavra

fim_printa_palavra:	
	li $v0, 11
	add $a0, $zero, 10
	syscall
	lw $ra, 0($sp)
	addi $sp,$sp,8
	jr $ra


#void adiciona_nos_chutes(char letra){
#	Chutes[Tentativas] = letra;
#	Tentativas++;
#}
#
adiciona_letra_nos_chutes:
	addi $sp,$sp,-4
	sw $ra, 0($sp)
	la $t0, Tentativas
	lw $t1, 0($t0)
	
	sb $a0, Chutes($t1)
	addi $t1,$t1,1
	sw $t1, 0($t0)

	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra


#Cuida de pegar a palavra do arquivo
#void Sorteia_Palavra(){
#	abrir_arquivo();
#	int linha_sorteada = retorna_numero_aleatório();
#	int posicao_no_buffer = retorna_posicao_do_sorteado(linha_sorteada);
#	return preencher_palavra(posicao_buffer);
#}
Sorteia_Palavra:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	jal abrir_arquivo
	jal retorna_numero_aleatório
	sw $v0, 4($sp)
	lw $a0, 4($sp)
	jal retorna_posicao_do_sorteado
	sw $v0, 4($sp)
	lw $a0, 4($sp)
	jal preencher_palavra
	lw $ra, 0($sp)
	jr $ra


#Jogo
#void Jogo(){
#	int tamanho_palavra = Sorteia_Palavra();
#	int vidas = 6;
#	while(vida != 0){
#		printa_forca(vidas);
#		printa_palavra(tamanho_palavra);
#		char letra = ler_caracter();
#		if(verifica_se_letra_ja_foi_usada) // tratar erro
#		adicionar_letra_nos chutes(letras);
#		if(!verifica_char_na_Palavra) vidas--;
#		if(verifica_se_ganhou){
#			ganhou();
#			return;	
#		}
#	}
#	perdeu();
#}
#

Jogo:
	addi $sp, $sp, -
	sw $ra, 0($sp)
	li $t0, 6
	sw $t0, 4($sp) # contador de vidas
while_Jogo:
	beqz $t0, fim_Jogo
	
fim_Jogo:

main:
	

	#addi $sp, $sp, -4 
	#addi $a0,$zero, 6
	#jal printa_palavra
	#jal Sorteia_Palavra
	#li $a0, '"'
	#li $v0, 11
	#syscall 
	#la $a0, Palavra
	#li $v0, 4
	#syscall 
	#li $a0, '"'
	#li $v0, 11
	#syscall 
	#li $a0, 0
	#jal printa_forca
#	jal Sorteia_Palavra
#	sw $v0, 0($sp)
#	lw $a0, 0($sp)
#	li $v0, 1
	
	#jal retorna_numero_aleatório
	#sw $v0, 0($sp)
	#lw $a0, 0($sp)
	#li $v0, 1
	#syscall
	
	#li $a0, 5
	#jal verifica_se_ganhou
	#sw $v0, 0($sp)
	#lw $a0, 0($sp)
	#li $v0, 1
	#syscall
	
	#jal verifica_se_letra_ja_foi_usada
	#sw $v0,0($sp)
	#lw $a0,0($sp)
	#li $v0, 1
	#syscall
	#jal ler_caracter
	#sw $v0,0($sp)
	#li $v0, 11
	#lw $a0,0($sp)
	#syscall
	#jal abrir_arquivo
	#li $a0,8
	#jal retorna_posicao_do_sorteador
	#sw $v0,0($sp)
	#lw $a0, 0($sp)
	#jal preencher_palavra
	#sw $v0,0($sp)
	#li $v0, 1
	#lw $a0, 0($sp)
	#syscall
	#li $v0, 4
	#la $a0, Palavra
	#syscall
	#lw $a0,0($sp)
	#li $a1, 'i'
	#jal verifica_char_na_Palavra
	#sw $v0,0($sp)
	#li $v0, 1
	#lw $a0, 0($sp)
	#syscall
	
