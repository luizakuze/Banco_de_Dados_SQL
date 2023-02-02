# w3schools.com 


##### Funções em Banco de Dados #####
# Executam determinadas ações ou tarefas pré compiladas e armazenadas
# no banco de dados sempre que for necessário executá-la.
# Funções são usadas para ações ou consultas repetitivas ou diárias.

# Criar uma function que será passado como 'parâmetro'/'argumento de função' o id do cadastro.
# Ela irá nos retornar o nome desse id.

delimiter $$  # criar blocos programáveis em sql. "Abre bloco de código"

create function retorna_nome1(id integer)   # create é um comando tipo DDL. Criar um objeto estrutural no banco de dados. NÃO é um registro. Aparece no Schema. Para apagar => DROP.
returns varchar(50) deterministic 
begin 													
declare nome varchar(50);                                 
select nome_cadastro into nome from cadastro              
where id_cad = id;
return nome;											
end $$

delimiter ;



delimiter $$
create function retorna_nome(id_cad_input int)
returns varchar(50) deterministic
begin
declare nome varchar(50);
select Nome_cadastro into nome
from cadastro
where id_cad = id_cad_input;
return nome;
end $$
delimiter ;

# Testar a function
select retorna_nome(5);

# Function para fazer um join
select nome_produtos, retorna_nome(8), Quantidade from produtos  # Aqui só faz a junção, falta a comparação (produtos.id_cad = cadastro.id_cad)

### Stored Procedure (stp) ###
# Diferença function e procedure: Na procedure não precisa de parâmetro e pode agendar pra quando ela vai ser executada.
# Lembrando que as procedures podem ser executadas manualmente ou em segundo plano.
# Cuidar com o excesso de procedures, deixa o banco de dados lento. Banco rápido é um banco bom.

delimiter $$

create procedure stp_select()
begin
select * from produtos;
end $$
delimiter $$

# Chamar/Executar uma procedure
call stp_select();


### Procedure de carga de dados
## Copia os registros da tabela produtos para produtos2

# truncate = Apaga todos os registros de uma tabela
select * from produtos2;
truncate produtos2;

# Exemplo do cursor = "Pega, descarrega (loop) e vai pra casa (no final)"

DELIMITER $$
CREATE PROCEDURE st_input_tabela_produtos2()
BEGIN
DECLARE done INT DEFAULT FALSE; # Tipo bool 
DECLARE INSERE_ID_PROD int default 0;
DECLARE INSERE_NOME varchar(30) default 0;
DECLARE INSERE_Valor float(10,2) default 0;
DECLARE INSERE_Quantidade int default 0;
DECLARE INSERE_ID_CAD int;
DECLARE cursor1 CURSOR FOR SELECT id_prod,Nome_produtos,Valor,Quantidade,id_cad from produtos;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; # done é a condição de parada do laço e cursor.
OPEN cursor1;
read_loop: LOOP # Laço
IF done THEN
LEAVE read_loop; 
END IF;

FETCH cursor1 INTO # É o descarregar do Cursor
INSERE_ID_PROD,INSERE_NOME,INSERE_VALOR,INSERE_QUANTIDADE,INSERE_ID_CAD;
insert into produtos2  # Descarrega na produtos2
Values(INSERE_ID_PROD,INSERE_NOME,INSERE_VALOR,INSERE_QUANTIDADE,INSERE_ID_CAD);
end loop;
CLOSE cursor1;
END $$
delimiter $$

## TESTES
# Chama a procedure para a carga da tabela
call st_input_tabela_produtos2();
select * from produtos2;
truncate produtos2;

## Criar um evento agendado para rodar a procedure

# Ativar o scheduler
set global event_scheduler = on;

## Criar uma tarefa agendada para rodar a procedure a cada 1 min
delimiter $$

create event chama_procedure on schedule every 1 minute
on completion not preserve disable # O sql sempre para a tarefa após 1 uso dela, esse comando tira isso
do 
call st_input_tabela_produtos2()

# Exibe as tarefas agendadas
show events;

# Ativar a tarefa agendada
alter event chama_procedure enable;

# Desativar a tarefa agendada
alter event chama_procedure disable;

# Apagar uma tarefa
drop event chama_procedure;

truncate produtos2;
select * from produtos2;

##### Triggers #####
# Cria a trigger condicionada a um evento. Tipos: after insert, after update ou after delete.
# Mais rápidas que as procedures.
# Exemplo1) A cada insert, a trigger é acionada.
# Exemplo2) No MCDonalds, o caixa lança o pedido (insert) e ele já aparece na telinha (trigger)

# Criar uma tabela para simular os eventos da trigger (tabela de vendas)
create table Itens_Venda (
id_venda int,
id_prod int, 
qt_vendida int
);

delimiter $

create trigger itens_venda_insert after insert  # Trigger acionada após um insert
on Itens_Venda 
for each row
begin
update produtos set quantidade = quantidade - new.qt_vendida # Quantidade produtos - Quantidade que foi vendida; NEW é o novo valor inserido
where id_prod = new.id_prod; # qual produto 
end$

create trigger itens_venda_delete after delete
on Itens_Venda
for each row
begin 
update produtos set quantidade = quantidade + old.qt_vendida
where id_prod = old.id_prod;
end$
delimiter $

## Testar as Triggers 
insert into itens_venda (id_venda, id_prod, qt_vendida) values (1, 6, 15);
select * from produtos;

# Para voltar o valor antes da trigger, deleta a trigger
delete from itens_venda
where id_venda = 1;

# Exibir as triggers
show triggers

# Apagar a trigger
drop trigger itens_venda_insert;

# Criar uma trigger condicional (condição de valor de campo de tabela)

## Implementar um capo de status de venda 
alter table itens_venda add column status_venda varchar (50);

## Criar a Trigger Condicional (if)
delimiter $

create trigger itens_venda_insert after insert 
on itens_venda
for each row
begin
if new.status_venda ='vendeu' then
update produtos set quantidade = quantidade - new.qt_vendida # Se vender, tira o produto que vendeu
where id_prod = new.id_prod;
end if;
if new.status_venda ='devolveu' then 
update produtos set quantidade = quantidade + new.qt_vendida
where id_prod = new.id_prod;
end if;
end$

delimiter $

## Testar as triggers com condicionais
# Para 'vendeu'
insert into itens_venda (id_venda, id_prod, qt_vendida, status_venda) values (1, 7, 10, 'vendeu'); 
# Para 'devoldeu'
insert into itens_venda (id_venda, id_prod, qt_vendida, status_venda) values (1, 7, 5, 'devolveu'); 

# Dá o histórico das vendas
select * from itens_venda;
