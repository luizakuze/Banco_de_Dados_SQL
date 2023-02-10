### Select e funções ###

## Criar uma tabela utilizando select (+ insert) ==> Geralmente usado para copiar tabelas
# Combinar select com outros comandos

## Lembrando que os () são executados primeiro
create table produtos2 (select * from produtos where quantidade >= 10); 

select * from produtos2;

## Copiar todos os registros da tabela produtos para produtos2 ==> Segunda forma
insert into produtos2 (select id_prod, Nome_Produtos, valor, quantidade, id_cad from produtos);

## Com update; Não recomendado!!
#update produtos2 set Nome_produtos = 'Abacaxi' 
#where nome_pr in ( select nome_produtos from produtos) 

### Funções de Agregação ###
# São responsáveis por agrupar valores onde o resultado 
# será um único

select quantidade, nome_cadastro as Cliente_Vendido
from produtos, cadastro                                 -- puxa as 2 tabelas
where produtos.id_cad = cadastro.id_cad                 -- campo de relação em comum
order by Quantidade; 									-- ordenação por número

## Group by = Agrupa registros repetidos

# Repetindo um registro 
insert into produtos (nome_produtos, valor, quantidade, id_cad) 
values ('Laranja', 3.50, 15, 1);
select * from produtos;


select nome_produtos, nome_cadastro, quantidade as QT_Vendida
from cadastro, produtos
where cadastro.id_cad = produtos.id_cad
group by nome_produtos, nome_cadastro, quantidade 
order by nome_produtos;

# Função COUNT = conta registros de uma tabela
# (*) contar tudo
select count(*) from produtos;
select count(nome_produtos) from produtos;

### Essa próxima consulta é bastante utilizada
select nome_cadastro, nome_produtos, count(nome_produtos) as Contagem_Produtos, sum(quantidade) as Quantidade_Produtos
from produtos, cadastro
where cadastro.id_cad = produtos.id_cad
group by nome_cadastro, nome_produtos
having count(nome_produtos) < 3;

## MAX e MIN = Máximo valor e mínimo valor
select min(Quantidade) as QT_PROD_MIN, max(Quantidade) as QT_PROD_MAX from produtos;

## SUM = Faz a soma total em um único valor; soma agregadora
select sum(Quantidade) as QT_PROD_TOTAL, format(sum(valor), 2) as VALOR_TOTAL
from produtos;

## Função avg = Faz a média
select format(avg(valor), 2) as Média from produtos;

### Funções de String ###
# Manipular valores de texto ou varchar

# O "like" é uma junção das duas funções
# Função Substring = Capturar uma parte dos dados
# Função length = Contar caracteres

select nome_produtos from produtos
where substr(Nome_produtos, 1, 2) = 'ma'			  -- Procura do primeiro ao quarto caracter a palavrinha "lara"
and length(nome_produtos) > 3;                        -- Número de caracteres tem que ser maior que 3 na buasca

## Concat e concat_ws ##

# Concat = Concatena o resultado das colunas
select concat(nome_cadastro, ' - Gosta de - ', nome_produtos) as Gosto_Frutas
from cadastro, produtos
where cadastro.id_cad = produtos.id_cad
order by Nome_cadastro;

# Concat_ws = Utiliza um separador para cada campo de um registro
#ex do arquivo csv
select concat_ws(',',nome_produtos, quantidade, valor)
from produtos
where nome_produtos like 'M%';

## lcase e ucase ##

# Lower Case = Letras em minúsculo
# Upper Case = Letras em maiúsculo

select lcase(nome_produtos) as Mainúsculo, ucase(nome_produtos) as Maiúsculo from produtos;

## Funções de Cálculo e Operadores aritméticos ##

# Round = Arredondamento
select round(3645.6333, 2) from dual;         		-- Dual => Tabela virtual, "só pra preencher", rodar

## Raíz Quadrada
select format(sqrt(443), 2) as RAÍZ_QUADRADA;

select pi();

## Cálculos Matemáticos: Adição, Subtração, Divisão e Multiplicação
# Exemplo para todas as operações
select (quantidade*valor) as MULTIPLICAÇÃO from produtos
where id_prod = 4;

###### Funções de Data ######

## Data atual
select curdate() as DATA_ATUAL;

## Data e hora atual
select now() as Data_e_Hora;
select sysdate();

## Hora
select curtime();    -- CAMPO TPO "TIME"

# Campo tipo date '2023-01-25'
# Campo tipo time '20:34:00' ou '8:34:00'PM

## Análises com valores de horas

select datediff('2023-01-30', '2020-06-01') as DIFERENÇA_DE_DIAS;

## Adicionar um valor a uma data 
select date_add(now(), interval 60 day);          -- Dia de hoje + 60 dias

## Dia da semana de uma data
select dayname('2018-09-28');

## Ano de uma data
select extract(year from '2022-09-01');

## Exportar o último dia do mês de uma tabela ou valor
select last_day('2021-02-01');

## Alterar o padrão de formato de data e hora
select date_format('2015-11-23', get_format(date, 'EUR')) as CONVERSÃO_FORMATO_EUROPEU;

## Transformar datas em formato texto para formato de data
select str_to_date('04.10.2020', get_format(date, 'USA'));

##### Condicionais; Uso de IF e CASE no SQL#####
# else if = case

# Testar a quantidade de frutas em estoque e trazer um resultado
# do select com alto e baixo (estoque)

select nome_produtos, Quantidade,
if(quantidade<=20, "Baixo", "Alto") as Estoque            -- condição, se verdadeiro, se falso
from produtos; 

## Validação de valores
select valor,
if (valor <> 10.00, "Diferente", "Igual") as valores                -- <> é o "diferente"
from produtos;

## Cenário de estoque, porém utilizando a função CASE,
# pois haverá mais de 1 condição verdadeira.

# O bloco CASE não conflita os valores <= 10 e <= 15, considera só um valor
# Considera a ordem de precedencia, nesse caso primeiro o 4, depois o 15 e o 30

select case 

when quantidade <= 4 then "Baixo Estoque"               -- when - quando; then - então

when quantidade <= 15 then "Estoque Bom"

when quantidade <= 30 then "Estoque Médio"

else 'Estoque Alto'
end as estadoestoque,           -- fim do bloco;  estadoestoque é o nome da coluna
count(*)estadoestoque
from produtos
group by estadoestoque
order by estadoestoque;

## Utilizar IF com JOIN
# Analisar clientes com compras de quantidade acima de 10

select nome_cadastro, nome_produtos, quantidade, 
if (quantidade >= 10, "Alto", "Baixo") as QT_Compras
from produtos join cadastro on 
cadastro.id_cad = produtos.id_cad
order by QT_Compras;

## Case classificando clientes com vendas boas e ruins
select case

when quantidade <= 10 then "Clientes com Poucas Vendas"
else "Clientes com Boas Vendas"

end as Compras_Cliente,
count(*) Compras_Cliente
from produtos join cadastro on 
cadastro.id_cad = produtos.id_cad
group by Compras_Cliente
order by Compras_Cliente;
