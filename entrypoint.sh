#!/bin/bash
set -e
ERROR=0
echo " ************** MODIFIED FILES"
printf ${MODIFIED_FILES}
printf "\n*****************************\n"


PATHS=$(printf ${MODIFIED_FILES} | tr \\n '\n')
while read -r local_file && [ ! -z "$local_file" ];
do
    #all local files must be found in changed files
    if ! grep "^$local_file\$" <<< "$PATHS" >/dev/null; then
        echo "Not found changes in local file '$local_file' when core file changed." >&2
        exit_code=102
    fi
    
    
    if [[ $local_file =~ ^app\/code\/local\/Mage\/(.+)$ ]] ; then
        echo "Unchangeable file is changed: ${PATH}"
        ERROR=1
    fi
    
    
    if [[ ${PATH} =~ ^app\/code\/community\/(.+)$ ]] ; then
        echo "Community file is changed: ${PATH}"
        ERROR=1
    fi

done < <(grep -P '^app/code/core/.' <<< "$PATHS" | sed --expression='s/^app\/code\/core/app\/code\/local/g')




exit "${ERROR}"
