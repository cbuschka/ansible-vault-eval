TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

generate_vault_password:
	@cd ${TOP_DIR}
	echo -n "$(shell dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 | head -c 32)" > ./vault_password.txt \
	&& chmod 600 ./vault_password.txt

store_secret_vars:
	@cd ${TOP_DIR}
	(ansible-vault encrypt_string --vault-password-file ./vault_password.txt --name secret_ingredient 'butter' --output - && \
	ansible-vault encrypt_string --vault-password-file ./vault_password.txt --name secret_ingredient2 'salt' --output -) > ./secret_vars.yml

run_playbook:
	@cd ${TOP_DIR}
	ansible-playbook --vault-password-file ./vault_password.txt -l localhost playbook.yml

clean:
	@cd ${TOP_DIR}
	rm -f ./vault_password.txt ./secret_vars.yml
