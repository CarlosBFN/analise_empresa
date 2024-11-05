-- 1.Explorar a base de dados de produtos para identificar preços que estão fora dos intervalos esperados.

-- 1.1.Verifica janela de preços dos produtos
WITH
media_precos AS(
    SELECT
        nome_produto
        ,ROUND(AVG(preco),2) AS media_precos

    FROM produtos

    GROUP BY 1
)

SELECT DISTINCT
    pr.nome_produto
    ,MAX(pr.preco)  AS maior_preco
    ,MIN(pr.preco)  AS menor_preco
    ,mp.media_precos

FROM produtos pr
    LEFT JOIN media_precos mp
        USING(nome_produto)

GROUP BY 1

ORDER BY 2 DESC
;


-- 1.2.Cria e popula a tabela de janela de preços aceitáveis para os produtos
CREATE TABLE janela_precos(
    produto STRING,
    valor_minimo INTENGER,
    valor_maximo INTENGER
)
;

INSERT INTO janela_precos(produto, valor_minimo, valor_maximo) VALUES 
("Bola de Futebol",	20,	100),
("Chocolate", 10, 50),
("Celular",	80, 5000),
("Livro de Ficção",	10,	200),
("Camisa", 80,	200)
;

SELECT * FROM janela_precos
;


-- 1.3.Verifica casos onde os preços estão fora da janela aceitável
WITH 
base AS(
    SELECT DISTINCT
        pr.nome_produto
        ,pr.preco
        ,jp.valor_minimo
        ,jp.valor_maximo
        ,CASE
            WHEN pr.preco > jp.valor_maximo THEN "Preço acima do teto"
            WHEN pr.preco < jp.valor_minimo THEN "Preço abaixo do piso"
            ELSE "Preço aceitável"
        END AS analise_preco

    FROM produtos pr
        LEFT JOIN janela_precos jp 
            ON pr.nome_produto = jp.produto 
)

SELECT 
    *
    ,COUNT(analise_preco) OVER(PARTITION BY analise_preco)  AS total_analise_preco

FROM base
;


-- 1.4.View para correção de preços fora da janela e verificação
CREATE VIEW preco_corrigido AS
    SELECT
        pr.id_produto
        ,pr.preco
        ,CAST(
            CASE
                WHEN pr.preco > jp.valor_maximo THEN jp.valor_maximo
                WHEN pr.preco < (jp.valor_minimo * 0.9) THEN jp.valor_minimo
                ELSE pr.preco
            END AS REAL) AS preco_corrigido

    FROM produtos pr
        LEFT JOIN janela_precos jp 
            ON pr.nome_produto = jp.produto
;

SELECT 
    p.*
    ,pr.preco_corrigido

FROM produtos p
    LEFT JOIN preco_corrigido pr
        USING(id_produto)