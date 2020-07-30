# -*- coding: utf-8 -*-
"""BeautifulSoup Receita/Fazenda Dados Públicos CNPJ

Este código demonstra como efetuar o webscrap da página da SEFAZ para
baixar os arquivos .ZIP com os dados públicos do Cadastro Nacional de 
Pessoas Jurídicas - CNPJ.

Após a execução, um arquivo download.txt será gerado.
Esse arquivo deve ser usado com o wget para download dos arquivos .ZIP
disponibilizados pela SEFAZ.

A utilização do wget é necessária, devido ao tamanho dos arquivos e da
taxa de transferência pequena do servidor da SEFAZ.
Com o wget é possível continuar o download caso a conexão caia e também 
possa ser execcutado posteriormente para atualização quando novos arquivos
sejam disponibilizados.

A atualização dos arquivos é trimestral.

Os aquivos da SEFAZ possuem informações adicionais, que são a lista de 
sócios. Essas informações são filtradas através dos scripts shell.

O script filtro.sh converte do formato da SEFAZ para CSV, com o caracter
separador | (PIPE). Podendo informar a UF para gerar arquivos CSV apenas
para o estado desejado.

Exemplo:
    ./filtro.sh MG

Os scripts filtro_xx.sh, farão de forma automática a geração dos arquivos
por UF, para cada uma respectivamente.

Requisitos:
        - Python: pip install BeautifulSoup4
        - Python: pip install Requests

Execução:

        $ python update.py

.. _Repositório da Tabela de Municípios:
   https://github.com/luizvaz/sql-basic-tables

.. _Package beautifulsoup4:
   https://www.crummy.com/software/BeautifulSoup/bs4/doc/#installing-beautiful-soup

"""

from bs4 import BeautifulSoup
from requests import head
from time import time as timer
from urllib.request import urlopen
from urllib.error import HTTPError, URLError

def sizeof_fmt(num, suffix='B'):
    for unit in ['','Ki','Mi','Gi','Ti','Pi','Ei','Zi']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    return "%.1f%s%s" % (num, 'Yi', suffix)

def main():
    start = timer()

    _url = 'http://receita.economia.gov.br/orientacao/tributaria/cadastros/' \
           'cadastro-nacional-de-pessoas-juridicas-cnpj/dados-publicos-cnpj'

    try:
        html = urlopen(_url)
    except HTTPError as e:
        print("Erro {} - {}".format(e.code, e.reason))
        return []
    except URLError as e:
        print("Erro de URL: {}".format(e.reason))
        return []

    bs = BeautifulSoup(html, 'html.parser')
    links = bs.find_all('a', attrs={'class': 'external-link'})

    results = []
    files = []
    for link in links:
        _href = str(link.attrs['href'])
        if '.zip' in _href.lower():

            # Informações do Arquivo
            _zip = head(_href)
            _mod = _zip.headers['Last-Modified']
            _len = _zip.headers['Content-Length']
            _typ = _zip.headers['Content-Type']

            _len = sizeof_fmt(int(_len))

            files.append(_href)
            results.append(f'{_href} : {_mod} - {_len}')

    with open('download.txt', 'w') as f:
        for item in files:
            f.write("%s\n" % item)

    print('Total URLs            : %s' % len(results))
    [print(f' - {x}') for x in results]
    print('Script Execution Time : %s' % (timer() - start,))


if __name__ == '__main__':
    main()

# End
