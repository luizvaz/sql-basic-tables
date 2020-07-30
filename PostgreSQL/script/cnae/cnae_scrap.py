# -*- coding: utf-8 -*-
"""IBGE CNAE Web Scraping

Os arquivos XLS podem ser baixados da url:
https://concla.ibge.gov.br/classificacoes/download-concla.html

O arquivo mais atual no momento é esse abaixo:
https://concla.ibge.gov.br/images/concla/documentacao/CNAE_Subclasses_2_3_Estrutura_Detalhada.xlsx

Execução:

        $ python cnae_scrap.py

.. _Repositório da Tabela de Municípios:
   https://github.com/luizvaz/sql-basic-tables

.. _Extensão Pandas e XLRD:
   pip install pandas
   pip install xlrd

"""

from urllib import request
from urllib.error import URLError

import os
import re
import pandas

dsc_size = 200

sql = """
DROP TABLE IF EXISTS cnae CASCADE;

CREATE TABLE cnae (
  id                   serial NOT NULL PRIMARY KEY,
  secao                varchar(1),
  secao_descricao      varchar({0}),
  divisao              varchar(2),
  divisao_descricao    varchar({0}),
  grupo                varchar(4),
  grupo_descricao      varchar({0}),
  classe               varchar(7),
  classe_descricao     varchar({0}),
  subclasse            varchar(9),
  subclasse_descricao  varchar({0}),
  codigo               integer
) WITH (
    OIDS = FALSE
  );

ALTER TABLE cnae
  OWNER TO postgres;

COMMENT ON COLUMN public.cnae.codigo
  IS 'Sem símbolos, somente numeros';
  
""".format(dsc_size)

# Execução como Script
if __name__ == "__main__":
    xls_file = 'CNAES.xlsx'
    on_size = 0

    # IBGE
    url = "https://concla.ibge.gov.br/images/concla/documentacao/CNAE_Subclasses_2_3_Estrutura_Detalhada.xlsx"
    try:
        meta = request.urlopen(url)
        on_size = int(meta.length)
    except URLError as e:
        print('Não foi possível acessar a URL de download...')
        exit()

    os_size = os.path.getsize(xls_file) if os.path.isfile(xls_file) else 0

    # Download somente se o arquivo não existe
    if on_size != os_size:
        request.urlretrieve(url, xls_file)

    # Pandas
    df = pandas.read_excel(xls_file, sheet_name=0)

    data = []
    secao_cod, grupo_cod, classe_cod, divisao_cod, subclasse_cod, \
    secao_dsc, grupo_dsc, classe_dsc, divisao_dsc, subclasse_dsc, \
    secao_len, grupo_len, classe_len, divisao_len, subclasse_len \
        = ('', '', '', '', '', '', '', '', '', '', 0, 0, 0, 0, 0)

    # Encontra o início dos dados
    for row in range(df.shape[0]):
        # Seção
        tmp = df.iat[row, 0]
        if isinstance(tmp, str) and len(tmp) == 1 and re.match('[A-Z]', tmp):
            secao_cod = tmp
            secao_dsc = df.iat[row, 5]
            secao_len = max(secao_len, len(secao_dsc))

        # divisao
        tmp = df.iat[row, 1]
        if isinstance(tmp, str) and re.match('\\d{2}', tmp):
            divisao_cod = tmp
            divisao_dsc = df.iat[row, 5]
            divisao_len = max(divisao_len, len(divisao_dsc))

        # grupo
        tmp = df.iat[row, 2]
        if isinstance(tmp, str) and re.match('\\d{2}\\.\\d', tmp):
            grupo_cod = tmp
            grupo_dsc = df.iat[row, 5]
            grupo_len = max(grupo_len, len(grupo_dsc))

        # classe
        tmp = df.iat[row, 3]
        if isinstance(tmp, str) and re.match('\\d{2}\\.\\d{2}-\\d', tmp):
            classe_cod = tmp
            classe_dsc = df.iat[row, 5]
            classe_len = max(classe_len, len(classe_dsc))

        # Código
        tmp = df.iat[row, 4]
        # Verifica se está no padrão
        if isinstance(tmp, str) and re.match('\\d{4}-\\d\\/\\d{2}', tmp):
            subclasse_cod = tmp
            subclasse_dsc = df.iat[row, 5]
            subclasse_len = max(subclasse_len, len(subclasse_dsc))
            # Append
            cod = int(re.sub('[^0-9]', '', subclasse_cod))
            data.append([secao_cod, secao_dsc, divisao_cod, divisao_dsc, grupo_cod, grupo_dsc, classe_cod, classe_dsc,
                         subclasse_cod, subclasse_dsc, cod])

    sql += "INSERT INTO cnae (secao, secao_descricao, divisao, divisao_descricao, grupo, grupo_descricao, classe, classe_descricao, subclasse, subclasse_descricao, codigo) values "
    sep = ""
    for row in data:
        values = ', '.join('\'{0}\''.format(w) for w in row)
        sql += "{0}\n({1})".format(sep, values)
        sep = ','

    file = "cnae.sql"
    file1 = open(file, "w")  # write mode
    file1.write(sql)
    file1.close()
    print("{0} - Gerado...".format(file))

    print("""Tamanho da Coluna Descrição precisa ser menor {0} 
    Secao max Length     - {1}
    Grupo max Length     - {2}
    Classe max Length    - {3}
    Divisao max Length   - {4}
    Subclasse max Length - {5}
     """.format(dsc_size, secao_len, grupo_len, classe_len, divisao_len, subclasse_len))
