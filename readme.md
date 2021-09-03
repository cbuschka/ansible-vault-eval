# ansible-vault Evaluation

## Requirements
* GNU make
* ansible

## Usage

### Generate a secret, this is used to encrypt values ("vault password")
```
make store_secret
```

### Generate encrypted var in vars file
```
make store_secret_vars
```

### Run playbook and on the fly decrypt encrypted vars
```
make run_playbook
```

## License

Copyright (c) 2021 by [Cornelius Buschka](https://github.com/cbuschka).

[MIT-0](./license.txt)
