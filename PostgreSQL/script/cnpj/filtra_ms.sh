#!/bin/bash

# Usage: filtra_ms.sh

UF="MS"
for i in {01..20}
do
  echo "ZIP $i"
  unzip -p DADOS_ABERTOS_CNPJ_"$i".zip | ./filtro.sh $UF > temp.csv
  iconv -c -f iso-8859-1 -t utf-8 temp.csv -o DADOS_ABERTOS_CNPJ_"$i"_"$UF".csv
  rm temp.csv
  zip -m -9 DADOS_ABERTOS_CNPJ_"$i"_"$UF".zip DADOS_ABERTOS_CNPJ_"$i"_"$UF".csv
done
