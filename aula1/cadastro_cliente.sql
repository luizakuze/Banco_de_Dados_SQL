-- comentários são linhas de código não lida spelo sql
# pode ser # ou -- duplo traço

# Criar a base de dados com comando DDL

create database basedados;

## Criar a primeira tabela chama cadastro
# Utilizando o comando do tipo DDL create

create table cadastro(
id_cad integer not null auto_increment,
Nome varchar(50) not null,
Sobrenome varchar(50) not null,
CPF varchar(11) not null,
primary key(id_cad)
);

### Utilizando o comando DML Insert para criar um registro 
# na tabela cadastro; o id o próprio sql cria/incrementa

insert into cadastro (nome,sobrenome,cpf)
values("Luiza","Kuze","1234");

## Executar um comando DQL Select para
# consultar e pesquisar os registros de uma tabela
# * trás todas as colunas da tabela cadastro, todos os campos

select * from cadastro;

#Sem o * pq não são todos os campos

select nome,sobrenome from cadastro;

# Apagar os registros da base de dados -> truncate cadastro;

## Sempre que vamos apagar ou fazer um update em algum
# registo de uma tabela precisamos ser especificos 
# utilizando clausula Where e passando campos de 
# valores únicos.

delete from cadastro where id_cad = 2;

select * from cadastro;

## Erro do safe update mode 1175

update cadastro set sobrenome = "Silva"
where sobrenome = "Kuze";

