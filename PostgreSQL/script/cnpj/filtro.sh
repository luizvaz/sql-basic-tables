#!/bin/bash

# Usage: INPUT | filtro.sh [UF] > OUTPUT
#
#  Sample: unzip -p file.zip | ./filtro.sh MG > cnpj_mg.csv


# Filtra por UF se informada
if [ -z "$1" ]
  then
    UF=""
else
        UF="$1"
fi

awk -v uf="$UF" -f <(cat - <<-'EOD'
        BEGIN {

                print "CNPJ|Matriz_Filial|Razao|Fantasia|Situacao_Cadastral|Data_Situacao|Motivo_Situacao|Cidade_Exterior|Codigo_Pais|Nome_Pais|Natureza_Juridica|Data_Inicio_Atividade|CNAE_Fiscal|Tipo_Logradouro|Logradouro|Numero|Complemento|Bairro|CEP|UF|Código_Municipio|Municipio|Telefone1|Telefone2|Fax|eMail|Qualificacao_Responsavel|Capital_Social|Porte_Empresa|Simples|Data_Opcao_Simples|Data_Exclusao_Simples|Opcao_MEI|Situacao_Especial|Data_Situacao_Especial"

        }

        {
                fields[01] = substr($0,  1,   2) #Indentificador


                if ( fields[1] != "1F" ) { next }

                # Filtra UF se informada
                if ( uf != "" && ( uf != substr($0, 683, 2) ) ) { next }

                fields[02] = substr($0,  4,  14) #Cnpj
                fields[03] = substr($0, 18,   1) #Matriz/Filial
                fields[04] = substr($0, 19, 150) #Razao
                fields[05] = substr($0,169,  55) #Fantasia
    fields[06] = substr($0,224,   2) #Situação Cadastral
                fields[07] = substr($0,226,   8) #Data Situação
                fields[08] = substr($0,234,   2) #Motivo Situação
                fields[09] = substr($0,236,  55) #Cidade Exterior
                fields[10] = substr($0,291,   3) #Código País
                fields[11] = substr($0,294,  70) #Nome País
                fields[12] = substr($0,364,   4) #Código Natureza Jurídica
                fields[13] = substr($0,368,   8) #Data Início Atividade
                fields[14] = substr($0,376,   7) #CNAE Fiscal
                fields[15] = substr($0,383,  20) #Tipo Logradouro
                fields[16] = substr($0,403,  60) #Logradouro
                fields[17] = substr($0,463,   6) #Numero
                fields[18] = substr($0,469, 156) #Complemento
                fields[19] = substr($0,625,  50) #Bairro
                fields[20] = substr($0,675,   8) #CEP
                fields[21] = substr($0,683,   2) #UF
                fields[22] = substr($0,685,   4) #Código Município
                fields[23] = substr($0,689,  50) #Município
                fields[24] = substr($0,739,  12) #Telefone 1
                fields[25] = substr($0,751,  12) #Telefone 2
                fields[26] = substr($0,763,  12) #Fax
                fields[27] = substr($0,775, 115) #eMail
                fields[28] = substr($0,890,   2) #Qualificação Responsável
                fields[29] = substr($0,892,  14) #Capital Social
                fields[31] = substr($0,906,   2) #Porte Empresa
                fields[32] = substr($0,908,   1) #Simples (0 - Não Optante, 5 e 7 - Optante, 6 e 8 Excluído)
                fields[33] = substr($0,909,   8) #Data Opção Simples
                fields[34] = substr($0,917,   8) #Data Exclusão Simples
                fields[35] = substr($0,925,   1) #Opção MEI (S - Sim)
                fields[36] = substr($0,926,  23) #Situação Especial
                fields[37] = substr($0,949,   8) #Data Situação Especial

                line = ""
    sep = ""
                for( i = 2 ; i<=37 ; i++)
                        { line = sprintf("%s%s%s", line, sep, trim(fields[i])); sep="|" }
                print line
        }

        function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
        function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
        function trim(s)  { return rtrim(ltrim(s)); }
EOD
)

