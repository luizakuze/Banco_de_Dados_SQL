# Cria a base de dados
create database basedados;


# Cria a tabela CLIENTES
create table clientes(
id_cad integer not null auto_increment,
nome_cliente varchar(50) not null,
sobrenome varchar(50) not null,
CPF varchar(11) not null,
primary key (id_cad)
);


# Cria a tabela VENDAS_PRODUTOS
create table vendas_produtos(
id_prod integer not null auto_increment,  
nome_produto varchar(50) not null,
valor float not null,
id_cad integer not null,  #chave estrangeira 
primary key (id_prod)
);


# Foreign Key     
alter table vendas_produtos add constraint fk_clientes_produtos
foreign key (id_cad)
references clientes(id_cad);


# Criando o campo "Quantidade" na tabela VENDAS_PRODUTOS que faltou
alter table vendas_produtos add column quantidade int after valor;


# Script insert para CLIENTES
insert into clientes (nome_cliente, sobrenome, CPF) Values('Luiza','Kuze',11111111111);
insert into clientes (nome_cliente, sobrenome, CPF) Values('Maria','Fernanda',22222222222);
insert into clientes (nome_cliente, sobrenome, CPF) Values('Isadora','Marques',33333333333);
insert into clientes (nome_cliente, sobrenome, CPF) Values('Gabriel','Souza',4444444444);
insert into clientes (nome_cliente, sobrenome, CPF) Values('Gustavo','Paulo',55555555555);

# Script insert para VENDAS_PRODUTOS
insert into vendas_produtos (nome_produto, valor, quantidade, id_cad) Values('Manga',8.50, 16, 1);
insert into vendas_produtos (nome_produto, valor, quantidade, id_cad) Values('Pera',10.50, 10, 2);
insert into vendas_produtos (nome_produto, valor, quantidade, id_cad) Values('Maçã',4.80, 4, 3);
insert into vendas_produtos (nome_produto, valor, quantidade, id_cad) Values('Mamão',8.00, 20, 4);
insert into vendas_produtos (nome_produto, valor, quantidade, id_cad) Values('Banana',6.50, 10, 5);


# Select com JOIN da tabela dos Clientes x Vendas Produtos
select nome_cliente as CLIENTES, nome_produto as PRODUTOS, quantidade as QUANTIDADE from vendas_produtos
join clientes on  
vendas_produtos.id_cad = clientes.id_cad 
order by nome_cliente;

