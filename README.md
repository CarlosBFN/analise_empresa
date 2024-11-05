# Análise Empresa

O projeto é uma análise completa do banco de dados de venda de uma empresa, que vai desde as primeiras observações gerais, manipulação e apresentação de _insights_.

O projeto cobre tópicos como joins, views, with, funções de agregação e manipulação de strings, e são adequados para estudantes e profissionais em busca de prática.

    Palavras-chave: SQL; JOIN; WITH; VIEW; filtros; análise


## Plataformas e ferramentas usadas

- **VSCode**: Usado como editor de código.
- **SQLite**: Extensão do VSCode para trabalhar com bancos de dados SQLite.
- **SQLite Online**: Usada para criar os arquivos '.db'. Pode também ser usada como ferramenta alternativa para executar queries SQL diretamente no navegador.

## Arquivos do projeto

1. README.md - Arquivo de texto que documenta o projeto
<br><br>

1. [Base de Vendas SQL](/data/processed/base_vendas_sql.db) - Base de dados de registro de vendas de uma empresa trabalhada via SQL
1. [Normatização](/normatizacao.sql) - Queries de normatização da base
1. [Análise](/analise.sql) - Queries de análise da base
<br> <br>


### Estrutura do projeto
```
exercicios_SQL/
│
├── data/                                       # Pasta de dados
│   ├── processed/                              # Pasta de dados processados
│   └── raw/                                    # Pasta de dados brutos, como foram obtidos
│
├── analise.sql                                 # Consulta SQL
├── normatizacao.sql                            # Consulta SQL
└── README.md                                   # Arquivo de documentação principal
```

### Como usar os arquivos

1. a) Baixe os bancos de dados (.db) da pasta `data/processed` e abra-os usando o SQLite no VSCode ou em outra ferramenta de sua escolha. b) Ou baixe os arquivos de criação das bases da pasta `data/raw` e as recrie. 

2. Abra os arquivos de query (.sql) e execute as consultas no banco de dados correspondente.

## Normatização
_Objetivo:_

1. Explorar a base de dados de produtos para identificar preços que estão fora dos intervalos esperados. Tabela de intervalos de preços aceitáveis:

|Produto | Preço Mínimo | Preço Máximo |
|---|---|:---|
|Bola de Futebol | 20 | 100 |
|Chocolate | 10 | 50 |
|Celular | 80 | 5000 |
|Livro de Ficção | 10 | 200 |
|Camisa | 80 | 200 |

## Análise

1. Verificar valores totais das tabelas do projeto
2. Compreender os principais períodos de vendas em meses
3. Analisar pontos sobre a _Black Friday_ para planejamento da próxima.
    - Qual o papel dos fornecedores na Black Friday?
    - Qual o fornecedor com o pior desempenho da BF?
    - Qual a categoria de produtos mais vendida da Black Friday?
    - Qual a marca de produtos mais vendida da Black Friday?
4. Verificar e planejar a performance das Black Friday anteriores e futuras.