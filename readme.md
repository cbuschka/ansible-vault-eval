# ansible-vault Evaluation

## Requirements
* GNU make
* ansible

## Usage

### Generate a vault password file, this is used to encrypt values

```
make generate_vault_password
```

Output:

```
[conni@herbie ansible-vault-eval]$ make generate_vault_password 
echo -n "qry4GbtuFYlKWystgpyZcGWwp4eH6LoO" > ./vault_password.txt \
&& chmod 600 ./vault_password.txt
```

### Generate encrypted var in vars file

```
make store_secret_vars
```

Output:

```
[conni@herbie ansible-vault-eval]$ make store_secret_vars 
(echo -n 'secret_ingredient: '; echo -en 'butter' | ansible-vault encrypt_string --vault-password-file ./vault_password.txt --output -) > ./secret_vars.yml
```

### How the secret_vars.yml looks like

```
[conni@herbie ansible-vault-eval]$ cat secret_vars.yml 
secret_ingredient: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          39666136656630323137306565336164383735383336653538643032326238663965323462323963
          6334393739633830626661336636626135316131633134330a363634663864666162333863353766
          30623535393032326437333337373262346266386638323037363430626239326236306432643537
          6433653166663830330a316639303238306265386261653833636539633836366363353338623036
          6464
```

### Run playbook and on the fly decrypt encrypted vars

```
make run_playbook
```

Output:

```
[conni@herbie ansible-vault-eval]$ make run_playbook 
ansible-playbook --vault-password-file ./vault_password.txt -l localhost playbook.yml
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [localhost] *********************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************
ok: [localhost]

TASK [Load vars] *********************************************************************************************************************************************
ok: [localhost]

TASK [Print secret ingredient] *******************************************************************************************************************************
ok: [localhost] => {
    "msg": "The secret ingredient is butter."
}

PLAY RECAP ***************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

### How decrypting with the wrong vault password looks like

Output:

```
[conni@herbie ansible-vault-eval]$ make run_playbook 
ansible-playbook --vault-password-file ./vault_password.txt -l localhost playbook.yml
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [localhost] *********************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Load vars] *********************************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print secret ingredient] *******************************************************************************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"msg": "Decryption failed (no vault secrets were found that could decrypt)"}

PLAY RECAP ***************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

make: *** [Makefile:14: run_playbook] Error 2
```

## License

Copyright (c) 2021 by [Cornelius Buschka](https://github.com/cbuschka).

[MIT-0](./license.txt)
