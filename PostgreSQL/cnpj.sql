
DROP TABLE IF EXISTS cnpj CASCADE;

CREATE TABLE cnpj (
  id                       serial NOT NULL PRIMARY KEY,
  CNPJ                     varchar(14) NOT NULL,
  Matriz_Filial            varchar(1),
  Razao                    varchar(150),
  Fantasia                 varchar(55),
  Situacao_Cadastral       varchar(2),
  Data_Situacao            varchar(8),
  Motivo_Situacao          varchar(2), 
  Cidade_Exterior          varchar(50),
  Codigo_Pais              varchar(3),
  Nome_Pais                varchar(70),
  Natureza_Juridica        varchar(4),
  Data_Inicio_Atividade    varchar(8),
  CNAE_Fiscal              varchar(7),
  Tipo_Logradouro          varchar(20),
  Logradouro               varchar(60),
  Numero                   varchar(6),  
  Complemento              varchar(156),
  Bairro                   varchar(50),
  CEP                      varchar(8),
  UF                       varchar(2),
  Código_Municipio         varchar(4),  
  Municipio                varchar(50),
  Telefone1                varchar(12),
  Telefone2                varchar(12), 
  Fax                      varchar(12),
  eMail                    varchar(115),
  Qualificacao_Responsavel varchar(2),
  Capital_Social           varchar(14), 
  Porte_Empresa            varchar(2),
  Simples                  varchar(1),  
  Data_Opcao_Simples       varchar(8),  
  Data_Exclusao_Simples    varchar(8),
  Opcao_MEI                varchar(1),
  Situacao_Especial        varchar(23),  
  Data_Situacao_Especial   varchar(8)
) WITH (
    OIDS = FALSE
  );

ALTER TABLE cnpj
  OWNER TO postgres;

COMMENT ON COLUMN public.cnpj.Situacao_Cadastral
  IS '01 - NULA, 02 - ATIVA, 03 - SUSPENSA, 04 - INAPTA, 08 - BAIXADA';

COMMENT ON COLUMN public.cnpj.Porte_Empresa
  IS '00 - NAO INFORMADO, 01 - MICRO EMPRESA, 03 - EMPRESA DE PEQUENO PORTE, 05 - DEMAIS';
  
COMMENT ON COLUMN public.cnpj.Data_Opcao_Simples
  IS '0 OU BRANCO - NÃO OPTANTE, 5 E 7 – OPTANTESPELO SIMPLES, 6 E 8 – EXCLUÍDO DO SIMPLES';
  
COMMENT ON COLUMN public.cnpj.Opcao_MEI
  IS 'S - SIM, N - NAO, OUTROS - BRANCO';
  
TRUNCATE TABLE cnpj RESTART IDENTITY;

--------------------------------------------------
-- OBS:
--
-- Antes de executar, descomente o código abaixo e
-- corrija manualmente a localização dos arquivos.
--
-- Exemplo: 
--   /home/admin/DADOS_ABERTOS_CNPJ_01.csv
--------------------------------------------------

/*
COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_01.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_02.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_03.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_04.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_05.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_06.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_07.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_08.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_09.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_10.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_11.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_12.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_13.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_14.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_15.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_16.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_17.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_18.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_19.csv' DELIMITER '|' CSV HEADER;

COPY cnpj (CNPJ,Matriz_Filial,Razao,Fantasia,Situacao_Cadastral,Data_Situacao,Motivo_Situacao,Cidade_Exterior,Codigo_Pais,Nome_Pais,Natureza_Juridica,Data_Inicio_Atividade,CNAE_Fiscal,Tipo_Logradouro,Logradouro,Numero,Complemento,Bairro,CEP,UF,Código_Municipio,Municipio,Telefone1,Telefone2,Fax,eMail,Qualificacao_Responsavel,Capital_Social,Porte_Empresa,Simples,Data_Opcao_Simples,Data_Exclusao_Simples,Opcao_MEI,Situacao_Especial,Data_Situacao_Especial)
FROM 'DADOS_ABERTOS_CNPJ_20.csv' DELIMITER '|' CSV HEADER;
*/