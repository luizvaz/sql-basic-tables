# -*- coding: utf-8 -*-
"""BeautifulSoup SEFAZ/MG Código TOM Scrap

Este código demonstra como efetuar o webscrap da página da SEFAZ/MG para
alimentar a tabela de municípios com o código TOM relativo a cada cidade.
A única relação no momento é pelo nome da cidade.

Alguns registros na tabela da SEFAZ não correspondem com os nomes da
tabela de municípios. Por isso o último passo cria um arquivo SQL
para corrigir os mesmos.

Alguns registros da tabela  de municípios também não existem na tabela da
SEFAZ, dessa forma o código TOM fica com valor zero.

O campo código TOM é originalmente no formato CHAR(4), com padding zero (0).
Na tabela de municípios esse campo está no formato smallint para otimizar a
alocação no banco.
Na hora de apresentar o resultado, basta fazer a formatação.

Na execução, serão gerados arquivos SQL para atualização do banco, no padrão
cod_tom-{xx}.sql. Onde {xx} será a UF e no por último um {zz} com a correção
dos registros com diferença já mapeados.

Requisitos:
        - Python: pip install BeautifulSoup4
        - PostgreSQL: CREATE EXTENSION unaccent;

Execução:

        $ python tom_scrap.py

Todo:
    * Criar arquivo shell correspondente ao .BAT

.. _Repositório da Tabela de Municípios:
   https://github.com/chinnonsantos/sql-paises-estados-cidades

.. _Package beautifulsoup4:
   https://www.crummy.com/software/BeautifulSoup/bs4/doc/#installing-beautiful-soup

.. _Extensão PostgreSQL UnAccent:
   https://www.postgresql.org/docs/9.5/unaccent.html
   Essa extensão é usada para poder comparar corretamente os
   nomes de muncípios e nomes da tabela TOM.

"""

from urllib.request import urlopen
from urllib.error import HTTPError, URLError
from bs4 import BeautifulSoup

# Coletar as páginas da lista de municipios
ufs = [['ac',  1], ['al',  2], ['am',  3], ['ap',  4], ['ba',  5], ['ce',  6], ['df',  7], ['es',  8], ['go',  9],
       ['ma', 10], ['ms', 12], ['mt', 13], ['pa', 14], ['pb', 15], ['pe', 16], ['pi', 17], ['pr', 18], ['rj', 19],
       ['rn', 20], ['ro', 21], ['rr', 22], ['rs', 23], ['sc', 24], ['se', 25], ['sp', 26], ['to', 27]]

mun = [['A', 11], ['B', 11], ['C', 11], ['D', 11], ['E', 11], ['F', 11], ['G', 11], ['H', 11], ['I', 11],
       ['J', 11], ['L', 11], ['M', 11], ['N', 11], ['O', 11], ['P', 11], ['Q', 11], ['R', 11], ['S', 11],
       ['T', 11], ['U', 11], ['V', 11], ['W', 11]]


def get_tom(fmt, cod, first):
    _url = str(fmt).format(cod[0].lower())
    _data = ""

    try:
        html = urlopen(_url)
    except HTTPError as e:
        print("UF: {0} - Erro {1}".format(uf.upper(), e.code))
        return []
    except URLError as e:
        print("Erro de URL: {0}".format(e.reason))
        return []

    bs = BeautifulSoup(html, 'html.parser')
    table = bs.find('table', attrs={'class': 'border'})

    # Pegar todo o texto da table de cidades
    rows = table.find_all('tr')
    for row in rows:
        cols = row.find_all('td')
        cols = [ele.text.strip() for ele in cols]
        if len(cols) == 3 and (cols[1]).isdigit():
            uf = cod[1]
            tom = cols[2]
            nome = str(cols[0]).replace("D'", "D`")
            _data += "update cidade set cod_tom = '{0}' where uf = {1} and upper(trim(unaccent(nome))) like '{2}'; \n".format(tom, uf, nome)

    return _data


# Execução como Script
if __name__ == "__main__":
    # UFs
    url = 'http://www.fazenda.mg.gov.br/governo/assuntos_municipais/codigomunicipio/codmunicoutest_{0}.html'
    for uf in ufs:
        data = get_tom(url, uf, uf[0])

        file = "cod_tom-{0}.sql".format(uf[0])
        file1 = open(file, "w")  # write mode
        file1.write(data)
        file1.close()
        print("{0} - Gerado...".format(file))

    # MG
    url = 'http://www.fazenda.mg.gov.br/governo/assuntos_municipais/codigomunicipio/codmunicmg_{0}.html'
    data = ""
    for m in mun:
        data += get_tom(url, m, 'mg')

    file = "cod_tom-mg.sql"
    file1 = open(file, "w")  # write mode
    file1.write(data)
    file1.close()
    print("{0} - Gerado...".format(file))

    # Correções
    data = ""
    data += "update cidade set cod_tom = '3365' where uf =  5 and upper(trim(unaccent(nome))) like 'BARRO PRETO%';\n"
    data += "update cidade set cod_tom = '3365' where uf =  5 and upper(trim(unaccent(nome))) like 'BARRO PRETO%';\n"
    data += "update cidade set cod_tom = '3291' where uf =  5 and upper(trim(unaccent(nome))) like 'LAJEDO DO TABOCAL';\n"
    data += "update cidade set cod_tom = '3005' where uf =  5 and upper(trim(unaccent(nome))) like 'MUQUEM DE%';\n"
    data += "update cidade set cod_tom = '0867' where uf = 10 and upper(trim(unaccent(nome))) like 'PINDARE-MIRIM';\n"
    data += "update cidade set cod_tom = '4049' where uf = 11 and upper(trim(unaccent(nome))) like 'AMPARO DO SERRA';\n"
    data += "update cidade set cod_tom = '4457' where uf = 11 and upper(trim(unaccent(nome))) like 'DONA EUSEBIA';\n"
    data += "update cidade set cod_tom = '4551' where uf = 11 and upper(trim(unaccent(nome))) like 'GOUVEIA';\n"
    data += "update cidade set cod_tom = '4955' where uf = 11 and upper(trim(unaccent(nome))) like 'PASSA-VINTE';\n"
    data += "update cidade set cod_tom = '0688' where uf = 11 and upper(trim(unaccent(nome))) like 'PINGO-D`AGUA';\n"
    data += "update cidade set cod_tom = '5303' where uf = 11 and upper(trim(unaccent(nome))) like 'SAO THOME DAS LETRAS';\n"
    data += "update cidade set cod_tom = '0688' where uf = 11 and upper(trim(unaccent(nome))) like 'PINGO-D`AGUA';\n"
    data += "update cidade set cod_tom = '0123' where uf = 13 and upper(trim(unaccent(nome))) like 'SANTA CARMEM';\n"
    data += "update cidade set cod_tom = '0834' where uf = 18 and upper(trim(unaccent(nome))) like 'BELA VISTA DA CAROBA';\n"
    data += "update cidade set cod_tom = '5495' where uf = 18 and upper(trim(unaccent(nome))) like 'PINHAL DE SAO BENTO';\n"
    data += "update cidade set cod_tom = '7843' where uf = 18 and upper(trim(unaccent(nome))) like 'SANTA CRUZ DE MONTE CASTELO';\n"
    data += "update cidade set cod_tom = '0770' where uf = 19 and upper(trim(unaccent(nome))) like 'ARMACAO DOS BUZIOS';\n"
    data += "update cidade set cod_tom = '1603' where uf = 20 and upper(trim(unaccent(nome))) like 'ACU';\n"
    data += "--update cidade set cod_tom = '0' where uf = 20 and upper(trim(unaccent(nome))) like 'AUGUSTO SEVERO';\n"
    data += "update cidade set cod_tom = '1653' where uf = 20 and upper(trim(unaccent(nome))) like 'CERRO CORA';\n"
    data += "--update cidade set cod_tom = '0' where uf = 20 and upper(trim(unaccent(nome))) like 'JANUARIO CICCO';\n"
    data += "update cidade set cod_tom = '1767' where uf = 20 and upper(trim(unaccent(nome))) like 'OLHO D`AGUA DO BORGES';\n"
    data += "--update cidade set cod_tom = '0' where uf = 20 and upper(trim(unaccent(nome))) like 'PRESIDENTE JUSCELINO';\n"
    data += "update cidade set cod_tom = '8419' where uf = 23 and upper(trim(unaccent(nome))) like 'ENTRE-IJUIS';\n"
    data += "update cidade set cod_tom = '8251' where uf = 24 and upper(trim(unaccent(nome))) like 'BALNEARIO PICARRAS';\n"
    data += "update cidade set cod_tom = '5739' where uf = 24 and upper(trim(unaccent(nome))) like 'LAJEADO GRANDE';\n"
    data += "update cidade set cod_tom = '8333' where uf = 24 and upper(trim(unaccent(nome))) like 'SAO LOURENCO DO OESTE';\n"
    data += "update cidade set cod_tom = '8339' where uf = 24 and upper(trim(unaccent(nome))) like 'SAO MIGUEL DO OESTE';\n"
    data += "update cidade set cod_tom = '3151' where uf = 25 and upper(trim(unaccent(nome))) like 'GRACHO CARDOSO';\n"
    data += "update cidade set cod_tom = '6423' where uf = 26 and upper(trim(unaccent(nome))) like 'FLORINIA';\n"
    data += "update cidade set cod_tom = '6715' where uf = 26 and upper(trim(unaccent(nome))) like 'MOGI GUACU';\n"
    data += "update cidade set cod_tom = '6717' where uf = 26 and upper(trim(unaccent(nome))) like 'MOGI MIRIM';\n"

    file = "cod_tom-zz.sql"
    file1 = open(file, "w")  # write mode
    file1.write(data)
    file1.close()
    print("{0} - Gerado...".format(file))
