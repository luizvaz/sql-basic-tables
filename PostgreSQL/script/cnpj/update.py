# -*- coding: utf-8 -*-
"""BeautifulSoup Receita.Fazenda - CNPJ

Requisitos:
        - Python: pip install BeautifulSoup4

"""

from requests import head
from time import time as timer
from urllib.request import urlopen
from urllib.error import HTTPError, URLError
from bs4 import BeautifulSoup

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
