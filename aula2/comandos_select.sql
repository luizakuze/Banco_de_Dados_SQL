## Comando DDL Alter  faz uma alteração estrutural de uma
# tabela ou objeto do banco de dados

# Adicionar campo CEP na tabela cadastro

select * from cadastro;

# Adicionar uma coluna CEP tipo varchar depois da coluna cpf

alter table cadastro add column CEP varchar(10) after cpf;

update cadastro set cep = '11'
where id_cad = 3 or id_cad = 6;     ## altera os 2 campos ao mesmo tempo;  #com o AND falaria que tem um cadastro com id_cad 3 e 6 ao mesmo tempo
                                     
                                     
insert into cadastro(id_cad,nome,sobrenome,cpf) values (2,"Pedro","Feliciano",'22222');


##### Trabalhando com Selects #####

## Order by ordena por uma coluna se for texto e ordem alfabética
# se for número ordinal 1 2 3

select nome, sobrenome from cadastro
order by nome;

select nome, sobrenome from cadastro
order by nome desc;    #decrescente

## Where (onde) utiliza uma condição 

select nome, sobrenome from cadastro
where nome = "Joao";   #tanto faz o acentuação (utf-8)

select nome, sobrenome from cadastro
where nome != "João";

select id_cad,nome, sobrenome from cadastro
where id_cad > 3;

## Busca coringa

select nome, sobrenome from cadastro
where nome like "Jo%"; # sabe como inicia (Jo) e não sabe como termina (%)

select nome, sobrenome from cadastro
where nome like "%ria"; # sabe como termina (ria) e não sabe como inicia (%)

select nome, sobrenome from cadastro
where sobrenome like "s%za";


##### Consultas Lógicas or(ou) and(e) not(negacao) #####

## 1 condição 
select nome, sobrenome from cadastro 
where nome = "Roberto" or sobrenome = "Silva";

##2 condições
select nome, sobrenome from cadastro
where nome = "Luiza" and sobrenome = "Silva";

select nome, sobrenome from cadastro
where not nome = "Roberto";

### Cláusulas in e not insert

## Trás registros com id 1 e 2
select id_cad, nome, sobrenome from cadastro
where id_cad in (1,2);

## Registros sem id 1 e 2
select id_cad, nome, sobrenome from cadastro
where id_cad not in (1,2);

## Registros em um intervalo entre 1 e 4
select id_cad, nome, sobrenome from cadastro
where id_cad between 1 and 4;

## Exemplo de busca entre intervalos de DATA 
# select id_cad, nome, sobrenome from cadastro
# where datacadastro between "2023-01-01" and "2023-31-01"; 

## Distinct trás apenas os valores distintos não repetidos; Se tiver 2 silvas (tem), ele dá a saída só com 1 silva
select distinct sobrenome from cadastro; 

##### Criar a segunda tabela e criar os relacionamentos #####
# No modelo lógico, a chave estrangeira ou no modelo físico, constraint

create table produtos(
id_prod integer not null auto_increment,  #incrementa automaticamente
nome varchar(50) not null,
valor float not null,
quantidade int(11) not null,
id_cad integer not null,  #chave estrangeira 
primary key (id_prod)
);

### até aqui as tabelas não estão interligadas
## Aqui, Cria a constraint que é a interligação física das tabelas

alter table produtos add constraint fk_cadastro_produtos ## ==> fk entre cadastro + produtos
foreign key (id_cad)
references cadastro(id_cad);

select * from cadastro;
select * from produtos;

##### Subconsulta ou SubSelects 
## É um select dentro de outro select

### Primeiro executa o () e armazena em memória. 
# Cadastros dentro da tabela produtos.
# Essas subconsultas também estão fazendo um join ("mais amador")

select nome, sobrenome from cadastro
where id_cad in (select id_cad from produtos where id_cad);

##Não estão dentro da tabela produtos
select nome, sobrenome from cadastro
where id_cad not in (select id_cad from produtos where id_cad);

### É um select com junção de duas tabelas
## Se existir registro "2" nas duas tabelas, trás o nome do produto de quem tem esse id
select nome, (select nome from cadastro where id_cad = produtos.id_cad)  ##tabela.campo
from produtos;

### Criar áreas nos campos para sair mais organizado ===> "as" para renomear a coluna
select nome as Produtos, (select nome from cadastro where id_cad = produtos.id_cad) as Compradores  ##tabela.campo;
from produtos;

#id_cad = produtos.id_cad) relaciona os valores das colunas


##### Cláusula Join #####

## Select sem join ; Valores de 2 tabelas 

select nome_cadastro,  sobrenome, nome_produtos, valor, quantidade
from produtos, cadastro
where cadastro.id_cad = produtos.id_cad
order by quantidade;

# Para corrigir o erro 1052 (ambiguidade), renomear os nomes dos campos das tabelas

alter table cadastro change nome nome_cadastro varchar(50);
alter table produtos change nome nome_produtos varchar(50);

## Select com join

select * from produtos
join cadastro

select nome_cadastro, nome_produtos, quantidade from produtos
join cadastro on  # pega a linha 154 e junte com a tabela cadastro
produtos.id_cad = cadastro.id_cad 
order by nome_cadastro;

#Exemplo 3 tabelas no join
#join estoque on
#produtos.id_prod = estoque.id_prod


## Quando precisar trazer valores ralacionados do select
# de 2 ou mais tabelas, é recomendado utilizar o join pela facilidade 
# e clareza relacional


## Joins para análise LEFT JOIN e RIGHT JOIN
# Compara valores da esquerda com a direita 
# e compara valores da direita para esquerda

## LEFT JOIN
select * from cadastro 
left join produtos on
produtos.id_cad = cadastro.id_cad;

## RIGHT JOIN
select * from produtos
right join cadastro on
produtos.id_cad = cadastro.id_cad;
