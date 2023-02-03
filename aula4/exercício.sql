# Cria a base de dados
create database biblioteca;


# Tabela para os alunos
create table Alunos (
id_aluno integer not null auto_increment,
Nome_Aluno varchar(50) not null,
Sobrenome varchar(50) not null,
RG varchar(11) not null,
primary key (id_aluno)
);


# Tabela para os livros da biblioteca
create table Livros (
id_livro integer not null auto_increment,
Nome_Livro varchar(50) not null,
Autor varchar(50) not null,
Quantidade int not null,
primary key (id_livro)
);


# Tabela para o histórico da circulação de livros (empréstimo na biblioteca)
# Os empréstimos são feitos a partir do RG dos alunos
create table Empréstimo_Livros (
id_empréstimo int,
id_livro int,
Status_Livro varchar(50)
);


# Entrada de dados para a tabela ALUNOS
insert into alunos (Nome_Aluno, Sobrenome, RG, id_aluno) Values('Luiza','Kuze','11111111111',1);
insert into alunos (Nome_Aluno, Sobrenome, RG, id_aluno) Values('Gustavo','Paulo','22222222222',2);
insert into alunos (Nome_Aluno, Sobrenome, RG, id_aluno) Values('Maria','Fernanda','33333333333',3);
insert into alunos (Nome_Aluno, Sobrenome, RG, id_aluno) Values('Isadora','Marques','44444444444',4);
insert into alunos (Nome_Aluno, Sobrenome, RG, id_aluno) Values('Rafael','Couto','55555555555',5);


# Entrada de dados para a tabela LIVROS
insert into livros (Nome_Livro, Autor, Quantidade, id_livro) Values('1984','George Orwell',30,1);
insert into livros (Nome_Livro, Autor, Quantidade, id_livro) Values('Admirável Mundo Novo','Aldous Huxley',20,2);
insert into livros (Nome_Livro, Autor, Quantidade, id_livro) Values('Código Limpo','Robert Cecil',10,3);
insert into livros (Nome_Livro, Autor, Quantidade, id_livro) Values('C Programming','K.N.King',10,4);
insert into livros (Nome_Livro, Autor, Quantidade, id_livro) Values('C Completo e Total','Herbert Schildt',10,5);


# Trigger after insert para funcionamento do histórico da biblioteca
delimiter $
create trigger status_livros_insert after insert 
on Empréstimo_Livros
for each row
begin
if new.Status_Livro ='empréstimo' then
update livros set Quantidade = Quantidade - 1 # Se pegar emprestado, retira 1 do estoque de livros
where id_livro = new.id_livro;
end if;
if new.Status_Livro ='devolução' then 
update livros set Quantidade = Quantidade + 1
where id_livro = new.id_livro;
end if;
end$
delimiter $


## Teste Triggers
# Para relizar um empréstimo de um livro
insert into Empréstimo_Livros (id_empréstimo, id_livro, Status_Livro) values (1, 2, 'empréstimo'); 
# Para relizar uma devolução de um livro
insert into Empréstimo_Livros (id_empréstimo, id_livro, Status_Livro) values (1, 2, 'devolução'); 


# Visualização das 3 tabelas criadas
select * from alunos;
select * from livros;
select * from Empréstimo_Livros;
