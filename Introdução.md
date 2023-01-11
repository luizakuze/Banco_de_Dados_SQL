## Banco de dados SQL

- Comando select -> Busca informações.

- SGDB -> Sistema Gerenciador de Banco de Dados

- Modelagem lógica-> Planejar o banco de dados. <br> *"Quantas tabelas?" "Oq vai ser armazenado?"*

- Campo -> Nome técnico de "coluna". 

```Somente backend se comunica com banco de dados```

---
### Características 

- Executa procedimentos chamados **transações**.

- Ação desfeita -> roolback. Ação  feita -> commit. Sql não tem como dar "ctrl Z", seria necessário um backup.

- Cada transação deve ser independente de outras transações.

---
### Banco de dados relacional

- Modela os dados de forma que sejam recebidos pelo usuário como tabelas, as **relações**. Uma "relação de dados, campos em comum". <br>**Ex.** Uma relação de nomes é ruim, pois podem ter várias pessoas com o mesmo nome. Deve ser utilizado códigos e valores únicos para realizar essas relaçoes.


___Exemplo <br>Tabelas que podem se relacionar a partir do departamento. (Cruzar informações)___

NumEmp| Dept
|---|---|
031|21
032|22
033|23


NumDep| NomeDept
|---|---|
|21| Financeiro 
|22| Técnico
|23| Pessoal
---
### Cardinalidade



"Em uma tabela pode repetir o número, na outra já não pode".

1:N, N:N, 1:1

**Ex1.** 1:N -> 1 para muitos. <br>
**Ex2.** N:N -> Muitos para muitos. **ruim!! - não recomendo.**

---
### Tipos de dados
- char x varchar; <br> **Ex1. String "Lulu" com vet[5]:** <br> No char: vet[5] -> [L] - [u] - [l] - [u] - [0/1] (preenche com valor binário se sobrar espaço); <br> No varchar: vet[5] -> [L] - [u] - [l] - [u] - [X](elimina o último caracter). ```É recomendado utilizar o varchar. ``` <br>**Ex2. "João", quantos caracteres?** Cinco, contando o ~.

- Alguns tipos mais utilizados: Datetime, date, time.
