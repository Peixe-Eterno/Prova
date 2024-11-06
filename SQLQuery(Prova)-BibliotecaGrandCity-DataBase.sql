
	/* Criação do  DataBase */
CREATE DATABASE BibliotecaGrandCity
GO

USE BibliotecaGrandCity
GO

	/* Tabela de Clientes */
CREATE TABLE DimClientes (
	ID_Clientes INT IDENTITY PRIMARY KEY,
	Nome VARCHAR(60),
	Sobrenome VARCHAR(40),
	DataNascimento DATE,
	Genero CHAR(1),
	CPF VARCHAR(11) UNIQUE,
	RG VARCHAR(11) UNIQUE,
	DataCadastro DATE
)

	/* Tabela de Livros */
CREATE TABLE DimLivros (
	ID_Livro INT IDENTITY PRIMARY KEY,
	Titulo VARCHAR(50),
	DataLancamento DATE,
	Autor VARCHAR(100),
	Escritora VARCHAR(100),
	Classificacao VARCHAR(5)
)

	/* Tabela Preços*/
CREATE TABLE DimLivrosPrecos (
	ID_Livro INT  PRIMARY KEY,
	PrecoAluguel FLOAT,
	PrecoCompra FLOAT
	FOREIGN KEY (ID_Livro) REFERENCES DimLivros(ID_Livro) -- Chave para indentificar o livro em questão
)

	/* Tabela Estoque de Livros */
CREATE TABLE DimEstoque (
	ID_Livro INT PRIMARY KEY,
	Estoque INT,
	[StatusQuantidade] VARCHAR(6),
	PedidoRemessa VARCHAR(1),
	ProximaRemessa DATE
	FOREIGN KEY (ID_Livro) REFERENCES DimLivros(ID_Livro) -- Chave para indentificar o livro em questão
)

	/* Venda ou Aluguel de Livros */
CREATE TABLE FactVenda (
	ID_Venda INT IDENTITY PRIMARY KEY,
	ID_Clientes INT,
	ID_Livro INT,
	Quantidade INT,
	FOREIGN KEY (ID_Clientes) REFERENCES DimClientes(ID_Clientes), --  Chave para indentificar o Cliente em questão
	FOREIGN KEY (ID_Livro) REFERENCES DimLivros(ID_Livro), -- Chave para indentificar o livro em questão
)





