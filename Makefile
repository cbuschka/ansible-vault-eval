TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

generate_vault_password:
	echo -n "$(shell dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 | head -c 32)" > ${TOP_DIR}/vault_password.txt \
	&& chmod 600 ${TOP_DIR}/vault_password.txt

store_secret_vars:
	(echo -n 'secret_ingredient: '; echo -en 'butter' | ansible-vault encrypt_string --vault-password-file ${TOP_DIR}/vault_password.txt --output -) > ${TOP_DIR}/secret_vars.yml

run_playbook:
	ansible-playbook --vault-password-file ${TOP_DIR}/vault_password.txt -l localhost playbook.yml

clean:
	rm -f ${TOP_DIR}/vault_password.txt ${TOP_DIR}/secret_vars.yml
