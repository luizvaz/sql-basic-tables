#!/bin/bash

# Usage: filtra_ms.sh

UF="MS"
for i in {01..20}
do
  echo "ZIP $i"
  unzip -p DADOS_ABERTOS_CNPJ_"$i".zip | ./filtro.sh $UF > DADOS_ABERTOS_CNPJ_"$i"_"$UF".csv
  zip -m -9 DADOS_ABERTOS_CNPJ_"$i"_"$UF".zip DADOS_ABERTOS_CNPJ_"$i"_"$UF".csv
done   
