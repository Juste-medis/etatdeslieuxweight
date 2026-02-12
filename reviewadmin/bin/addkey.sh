#!/bin/bash

cd /home/juste/AppFlutter/etatdeslieux/reviewapp/lib/l10n/

for file in intl_fr.arb intl_en.arb intl_pt.arb intl_es.arb; do
    equipment=$(echo "$file" | grep -q "fr" && echo "Équipement" || \
               (echo "$file" | grep -q "pt" && echo "Equipamento" || \
               (echo "$file" | grep -q "es" && echo "Equipo" || \
               echo "Equipment")))

    jq --arg equipment "$equipment" '{
        "equipment": $equipment
    } + .' "$file" > tmp && mv tmp "$file"
done
