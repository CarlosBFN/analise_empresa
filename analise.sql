-- 1. Verificar valores totais das tabelas do projeto

SELECT COUNT(*) as Qtd_Categorias FROM categorias;

SELECT COUNT(*) as Qtd_Clientes  FROM clientes;

SELECT COUNT(*) as Qtd_Fornecedores  FROM fornecedores;

SELECT COUNT(*) as Qtd_ItensVenda  FROM itens_venda;

SELECT COUNT(*) as Qtd_Marcas  FROM marcas;

SELECT COUNT(*) as Qtd_Produtos  from produtos;

SELECT COUNT(*) as Qtd_Vendas  from vendas;


-- 2. Compreender os principais meses de vendas

SELECT
    strftime("%Y/%m", v.data_venda) AS ano_mes
    ,COUNT(DISTINCT v.id_venda)     AS qt_total_pedidos
    ,SUM(total_venda)               AS valor_total_venda

FROM vendas v

GROUP BY 1
ORDER BY 2 DESC
;


-- 3. Analisar pontos sobre a Black Friday para planejamento da próxima.
    -- Qual o papel dos fornecedores na Black Friday?
    -- Qual o fornecedor com o pior desempenho da BF?
    -- Qual a categoria de produtos mais vendida da Black Friday?
    -- Qual a marca de produtos mais vendida da Black Friday?

-- Rankeando os fornecedores por volume e valor de venda
WITH 
    base_fornecedores as(
        SELECT 
            strftime("%Y/%m", v.data_venda) AS ano_mes
            ,f.nome                         AS nome_fornecedor
            ,COUNT(iv.produto_id)           AS qtd_vendas
            ,ROUND(SUM(total_venda),2)      AS valor_venda

        FROM itens_venda iv
            JOIN produtos p 
                ON p.id_produto = iv.produto_id

            JOIN fornecedores f 
                ON f.id_fornecedor = p.fornecedor_id

            LEFT JOIN vendas v
                ON iv.venda_id = v.id_venda

        WHERE TRUE
            AND strftime("%m", v.data_venda) = "11"

        GROUP BY 1,2
    )

    ,base_rank AS(
        SELECT
            ano_mes
            ,nome_fornecedor
            ,qtd_vendas
            ,RANK() OVER(PARTITION BY ano_mes ORDER BY qtd_vendas DESC, valor_venda DESC) AS rank_qtd_vendas
            ,valor_venda
            ,RANK() OVER(PARTITION BY ano_mes ORDER BY valor_venda DESC, qtd_vendas DESC) AS rank_valor_venda

        FROM base_fornecedores

        GROUP BY 1,2,3,5
)

SELECT
    ano_mes
    ,nome_fornecedor
    ,qtd_vendas
    ,rank_qtd_vendas
    ,valor_venda
    ,rank_valor_venda
    ,RANK() OVER(PARTITION BY ano_mes ORDER BY rank_geral)  AS rank_geral

FROM(
    SELECT *
        ,(CAST(rank_qtd_vendas AS REAL) + CAST(rank_valor_venda AS REAL)) /2    AS rank_geral_ano

    FROM base_rank
)

ORDER BY ano_mes,rank_geral
;

-- Rankeando as categorias de produtos mais vendidos na Black Friday
SELECT
    c.nome_categoria
    ,COUNT(iv.produto_id)    AS qt_produtos
    ,ROW_NUMBER() OVER(ORDER BY COUNT(iv.produto_id) DESC)  AS rank
    

FROM itens_venda iv 
    LEFT JOIN vendas v 
        ON iv.venda_id = v.id_venda

    LEFT JOIN produtos p 
        ON p.id_produto = iv.produto_id

    JOIN categorias c 
        ON c.id_categoria = p.categoria_id

WHERE TRUE
    AND strftime("%m", v.data_venda) = "11"

GROUP BY 1
ORDER BY 2 DESC
;

-- Rankeando as marcas de produtos mais vendidos na Black Friday
SELECT
    m.nome  AS nome_marca
    ,COUNT(iv.produto_id)    AS qt_produtos
    ,ROW_NUMBER() OVER(ORDER BY COUNT(iv.produto_id) DESC)  AS rank
    

FROM itens_venda iv 
    LEFT JOIN vendas v 
        ON iv.venda_id = v.id_venda

    LEFT JOIN produtos p 
        ON p.id_produto = iv.produto_id

    JOIN marcas m 
        ON p.marca_id = m.id_marca

WHERE TRUE
    AND strftime("%m", v.data_venda) = "11"

GROUP BY 1
ORDER BY 2 DESC
;


-- 4. Verificar e planejar a performance das Black Friday anteriores e futuras.