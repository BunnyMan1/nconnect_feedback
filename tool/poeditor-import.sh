#!/bin/bash

apiToken=$POEDITOR_API_TOKEN
projectId=347065
l10nPath="lib/src/common/translation/l10n"

declare -a defaultTranslations
# The default locale should always be the first one
# to have the fallback translations for all other locales
for lang in "en" "ar" "zh-CN" "da" "nl" "fr" "de" "hu" "ko" "pl" "pt" "ru" "es" "tr"; do
    echo $lang
    command=$(curl -X POST https://api.poeditor.com/v2/projects/export \
        -d api_token="$apiToken" \
        -d id="$projectId" \
        -d language="$lang" \
        -d type="key_value_json" | jq -r ".result.url")
    file="${l10nPath}/intl_$lang.json"
    curl "$command" -o "$file"

    langFile="${l10nPath}/messages_$lang.dart"

    printf "import 'package:wiredash/wiredash.dart';\n\n" >"$langFile"
    printf "class WiredashLocalizedTranslations extends WiredashTranslations {\n" >>"$langFile"
    printf "  const WiredashLocalizedTranslations() : super();\n" >>"$langFile"

    keys=($(jq -r 'keys_unsorted[]' "$file"))
    values=$(jq -r 'values[]' "$file")

    SAVEIFS=$IFS # Save current IFS
    IFS=$'\n'    # Change IFS to new line

    # Populate array of values
    declare -a array
    n=0
    for line in "${values[@]}"; do
        array+=($line)
        n=$(($n + 1))
    done

    # Print keys and values to Dart class
    n=0
    for key in "${keys[@]}"; do
        printf "   @override\n" >>$langFile
        if [ -z "${array[$n]}" ]; then
          translation="${defaultTranslations[$n]}"
        else
          translation="${array[$n]}"
        fi
        printf "   String get %s => \"%s\";\n" $key "$translation" >>$langFile
        n=$(($n + 1))
    done

    IFS=$SAVEIFS # Restore IFS

    printf "}" >>"$langFile"

    # Save the default locale translations for future use
    if [ "$lang" == "en" ]; then
      defaultTranslations=("${array[@]}")
    fi
    unset array
    unset keys
    unset values
    unset translation
    unset n
done

# fix wrong file name
mv "$l10nPath/messages_zh-CN.dart" "$l10nPath/messages_zh_cn.dart"

dartfmt -w $l10nPath
