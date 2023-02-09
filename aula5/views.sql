#### Views de Banco de Dados => Construção de selects. É uma "virtual table", um atalho de tabelas.
## Para consultas que terão que ser realizadas periodicamente.
# Acessam informações das tabelas físicas reais chamadas de based tables.
# É nela que com o power bi apresenta todas as informações das tabelas juntas, um dashboard completo.


## Construindo uma VIEW fazendo JOIN da consulta da tabela cadastro e produtos.

# Se errar algo, pode utilizar o REPLACE, não utilizando o DROP.
create or replace view cadastro_produtos as # criando ou atualizando uma VIEW. 
select nome_cadastro, nome_produtos, quantidade, valor, CPF
from cadastro
join produtos on #Join quando trazer campos de outras tabelas (ex. nome_produtos).
cadastro.id_cad = produtos.id_cad
order by nome_cadastro

# Já tem o join, é uma consulta completa.
select * from cadastro_produtos;

#Criando uma segunda view
create or replace view view2 as
select nome_cadastro, quantidade
from cadastro
join produtos on 
cadastro.id_cad = produtos.id_cad
order by quantidade;

select * from view2;


#### Índices de Banco de Dados => Um cash rápido, entregar determinadas ações com prioridade e mais rapidamente.
## Não pode ter índice em tudo, "quando tudo tem priodidade, nada tem prioridade".
# Otimizam consultas em cima de campos de tabelas que sofrem muitas consultas ou levam muito tempo para completar a consulta.
# Ver processos no banco de dados

# Analisa quais tabelas recebem mais consultas
show processlist 


create table cliente(
id_cliente integer not null auto_increment,
cod_cliente varchar(10),
nome varchar(50),
sobrenome varchar(50),
CPF varchar(11),
d_cadastro date,
primary key(id_cliente),
index ind_cod_cliente(cod_cliente)
);

## Adicionar um indice a uma tabela ja existente

alter table cliente add index ind_nome_cliente(nome);

alter table cadastro add index ind_nome_cadastro(nome_cadastro);

## Mostra os indexes
show indexes from cadastro;

##### Exportar Dados de Banco de Dados e Importar em formato em CSV

## Exportar a nossa tabela

# Erro 1290, tem que ter uma pasta específica 

select * from produtos into outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/lista_produtos.csv'
fields terminated by ';' enclosed by '''';

## Barras Diretórios => /linux e \windons

## Propriedades de uma variável 
# ****like buscava palavras coringa
show variables like "secure_file_priv" 

## Criar tabela que recebe os dados importados
# Warning da relação do campo integer
# Exportar arquivos como csv, pois qqr sistema entende 

create table importvendas (
CodigoPedido int(10),
EmailCliente varchar(100),
CodigoCliente integer(10), # Sem o integer, fica máximo que o campo pode suportar
Qtd integer(10),
CodigoProduto integer(10),
CategoriaProduto varchar(50),
primary key(CodigoPedido)
);


## Importar os dados do arquivo
# Com arquivo CSV e com separação ';'

load data infile  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clientes.csv'
into table importvendas fields terminated by ';' lines terminated by '\n'
ignore 1 rows;

select * from importVendas;


