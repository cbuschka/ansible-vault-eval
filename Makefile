TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

store_secret:
	echo -n "asdfasdf" > ${TOP_DIR}/secret.txt \
	&& chmod 600 ${TOP_DIR}/secret.txt

store_secret_vars:
	(echo -n 'secret_ingredient: '; echo -en 'butter' | ansible-vault encrypt_string --vault-password-file ${TOP_DIR}/secret.txt --output -) > ${TOP_DIR}/secret_vars.yml

run_playbook:
	ansible-playbook --vault-password-file ${TOP_DIR}/secret.txt -l localhost playbook.yml

clean:
	rm -f ${TOP_DIR}/secret.txt ${TOP_DIR}/secret_vars.yml
