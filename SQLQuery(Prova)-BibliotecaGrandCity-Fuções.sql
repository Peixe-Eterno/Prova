
INSERT INTO DimClientes (Nome,Sobrenome ,DataNascimento,Genero,CPF,RG)
VALUES
	('Maria','Clara Barbosa','19/03/2000','F', 12345678910 ,15482637581),
	('Luiza','Barsa','10/01/1990','F', 78910123456 ,12345786428),
	('Joaquim','Souza','15/7/2001','M', 56789123410 ,56887910103),
	('Tomas','Turbando','29/12/1988','F', 12891345670 ,75101187943)

INSERT INTO DimLivros (Titulo,DataLancamento ,Autor,Escritora,Classificacao)
VALUES
	('O Pequeno Principe','02/05/1968','Magalhães','Great Book','Livre'),
	('Rosaria','11/09/1953','GeGe','Great Book','+12'),
	('A Mascara De Ferro','30/12/1989','Magalhães','Sakir','+18'),
	('A Sombra do Rei','08/12/1997','Melisa','Sakir','+18'),
	('As Aventuras de Tintin','18/05/1997','Sera','Books worm','Livre')

INSERT INTO DimLivrosPrecos (ID_Livro,PrecoAluguel,PrecoCompra)
VALUES
	(1, 21.99, 35.99),
	(2, 32.59, 48.89),
	(3, 45.70, 69.99),
	(4, 50.00, 86.50),
	(5, 23.20, 34.99)

INSERT INTO DimEstoque (ID_Livro,Estoque,[StatusQuantidade],PedidoRemessa,ProximaRemessa)
VALUES
	( 1, 12, 'Baixo', 'S','11/11/2024'),
	( 2, 25, 'Medio', 'N',''),
	( 3, 48, 'Alto', 'N',''),
	( 4, 0, 'Vazio', 'S','7/11/2024'),
	( 5, 23, 'Medio', 'S','18/11/2024')

INSERT INTO FactVenda (ID_Clientes,ID_Livro,Quantidade)
VALUES
	(2, 1, 1),
	(3, 4, 1),
	(3, 3, 1),
	(1, 2, 1),
	(4, 5, 1),
	(4, 1, 1)
		
		
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

CREATE OR ALTER TRIGGER Data_Cadastro ON DimClientes
AFTER INSERT
AS
BEGIN
	UPDATE DimClientes
	SET DataCadastro = GETDATE() -- Pega a data atual
	FROM DimClientes C
	INNER JOIN inserted I ON C.ID_Clientes = I.ID_Clientes -- compara a id para não colocar a data em outro lugar
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
	@RG = '14579683224'

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
	@Titulo = 'A Rosa e o ladrão',
	@DataLancamento = '24/05/2008',
	@Autor = 'Martins',
	@Escritora = 'Grand Book',
	@Classificacao = '+12'


		/* VIEWS */
/* Uma View para ter visão rapida dos livros Comprados*/
CREATE VIEW V_Vendas
AS SELECT 
	FactVenda.ID_Clientes,
	Nome,
	FactVenda.ID_Livro,
	Titulo,
	Classificacao,
	PrecoCompra
FROM FactVenda
JOIN DimClientes ON DimClientes.ID_Clientes = FactVenda.ID_Clientes
JOIN DimLivros ON DimLivros.ID_Livro = FactVenda.ID_Livro
JOIN DimLivrosPrecos ON DimLivrosPrecos.ID_Livro = DimLivros.ID_Livro

SELECT * FROM V_Vendas

		/*CTE's (Common Table Expressions) */
	/* Uma CTE para ter visão da idade e genero dos compradores */
WITH ConsultDetalhada AS (
SELECT 
	DISTINCT Nome,
	DataNascimento,
	Genero,
	SUM(PrecoCompra) OVER (PARTITION BY DimClientes.ID_Clientes) AS Compra
FROM DimClientes
    
INNER JOIN FactVenda ON FactVenda.ID_Clientes = DimClientes.ID_Clientes
INNER JOIN DimLivros ON DimLivros.ID_Livro = FactVenda.ID_Livro
INNER JOIN DimLivrosPrecos ON DimLivrosPrecos.ID_Livro = DimLivros.ID_Livro
)

SELECT * FROM ConsultDetalhada

		/* Subqueries */
	/* */

SELECT
	DISTINCT ID_Livro,
	SUM(Valor) OVER (ORDER BY ID_Livro)
FROM (
	SELECT
	ID_Clientes,
	Quantidade,
	DimLivros.ID_Livro,
	SUM(Quantidade*PrecoCompra) OVER (PARTITION BY ID_Clientes) AS Valor
	FROM FactVenda
	Inner join DimLivrosPrecos ON DimLivrosPrecos.ID_Livro = FactVenda.ID_Livro
	Inner join DimLivros ON DimLivros.ID_Livro = FactVenda.ID_Livro
	) AS Subqueries
