
		/* TRIGGER */
	/*Informa o sucesso na inserção de dados na tabela DimClientes*/
CREATE OR ALTER TRIGGER Cliente_Adicionado ON DimClientes
AFTER INSERT
AS
BEGIN
	DECLARE @ultimo_nome VARCHAR(100);
	SELECT @ultimo_nome = Nome FROM DimClientes ORDER BY ID_Clientes ASC;

	PRINT @ultimo_nome + ' adicionado com sucesso'
END
GO

	/*Informa o sucesso na inserção de dados na tabela DimLivros*/
CREATE OR ALTER TRIGGER Livro_Adicionado ON DimLivros
AFTER INSERT
AS
BEGIN
	DECLARE @Titulo VARCHAR(100);
	SELECT @Titulo = Titulo FROM DimLivros ORDER BY ID_Livro ASC;

	PRINT @Titulo + ' adicionado com sucesso'
END
GO

		/* PROCEDURES */
	/* Apaga a procedure */
IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'SP_ADD_CONSULTA')
	BEGIN
		DROP PROCEDURE SP_ADD_CONSULTA
	END
GO

IF EXISTS (SELECT 1 FROM SYS.objects WHERE TYPE = 'P' AND NAME = 'SP_ADD_Livros')
	BEGIN
		DROP PROCEDURE SP_ADD_CONSULTA
	END
GO
	
	/* Cria uma procedure que facilita a incerção de dados nas tabelas */
CREATE PROCEDURE SP_ADD_Clientes
    @Nome VARCHAR(60),
	@Sobrenome VARCHAR(40),
	@DataNascimento DATE,
	@Genero CHAR(1),
	@CPF VARCHAR(11),
	@RG VARCHAR(11)
 
AS
    INSERT INTO DimClientes(Nome, Sobrenome, DataNascimento, Genero, CPF, RG)
    VALUES (@Nome, @Sobrenome, @DataNascimento, @Genero, @CPF, @RG)
GO

EXEC SP_ADD_Clientes
	@Nome = 'Danilo',
	@Sobrenome = 'Sampaio' ,
	@DataNascimento = '30/1/1975', 
	@Genero = 'M',
	@CPF = '18861481124',
	@RG = '18861481124'

	/* Cria uma procedure que facilita a incerção de dados nas tabelas */
CREATE PROCEDURE SP_ADD_Livros
	@Titulo VARCHAR(50),
	@DataLancamento DATE,
	@Autor VARCHAR(100),
	@Escritora VARCHAR(100),
	@Classificacao VARCHAR(5)
   
AS
    INSERT INTO DimLivros(Titulo, DataLancamento, Autor, Escritora, Classificacao)
    VALUES (@Titulo, @DataLancamento, @Autor, @Escritora, @Classificacao)
GO

EXEC SP_ADD_Livros
	@Titulo = 'O Pequeno Principe',
	@DataLancamento = '24/05/2008',
	@Autor = 'Martins',
	@Escritora = 'Grand Book',
	@Classificacao = '+12'


		/* VIEWS */
	/* Uma Views para ter visão rapida dos livros alugados*/
CREATE VIEW V_Aluguel AS

SELECT 
	FactAluguel.ID_Clientes,
	Nome,
	FactAluguel.ID_Livro,
	Titulo,
	Classificacao

FROM FactAluguel
JOIN DimClientes ON DimClientes.ID_Clientes = FactAluguel.ID_Clientes
JOIN DimLivros ON DimLivros.ID_Livro = FactAluguel.ID_Livro

SELECT * FROM V_Aluguel

/* Uma Views para ter visão rapida dos livros Comprados*/
CREATE VIEW V_Compra AS

SELECT 
	FactVenda.ID_Clientes,
	Nome,
	FactVenda.ID_Livro,
	Titulo,
	Classificacao

FROM FactVenda
JOIN DimClientes ON DimClientes.ID_Clientes = FactVenda.ID_Clientes
JOIN DimLivros ON DimLivros.ID_Livro = FactVenda.ID_Livro

SELECT * FROM V_Aluguel

