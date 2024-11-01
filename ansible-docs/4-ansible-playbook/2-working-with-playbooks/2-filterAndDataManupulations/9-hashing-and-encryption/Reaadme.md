<!--Hashing and encrypting strings and passwords-->
New in version 1.9.

To get the sha1 hash of a string:

    {{ 'test1' | hash('sha1') }}
    
# => "b444ac06613fc8d63795be9ad0beaf55011936ac"

Get a string checksum:

    {{ 'test2' | checksum }}
    
# => "109f4b3c50d7b0df729d299bc6f8e9ef9066971f"

Other hashes (platform dependent):

    {{ 'test2' | hash('blowfish') }}
    
To get a sha512 password hash (random salt):

    {{ 'passwordsaresecret' | password_hash('sha512') }}

# => "$6$UIv3676O/ilZzWEE$ktEfFF19NQPF2zyxqxGkAceTnbEgpEKuGBtk6MlU4v2ZorWaVQUMyurgmHCh2Fr4wpmQ/Y.AlXMJkRnIS4RfH/"

To get a sha256 password hash with a specific salt:

    {{ 'secretpassword' | password_hash('sha256', 'mysecretsalt') }}

# => "$5$mysecretsalt$ReKNyDYjkKNqRVwouShhsEqZ3VOE8eoVO4exihOfvG4"

An idempotent method to generate unique hashes per system is to use a salt that is consistent between runs:

    {{ 'secretpassword' | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }}
    
# => "$6$43927$lQxPKz2M2X.NWO.gK.t7phLwOKQMcSq72XxDZQ0XzYV6DlL1OD72h417aj16OnHTGxNzhftXJQBcjbunLEepM0"

Hash types available depend on the control system running Ansible, ansible.builtin.hash depends on hashlib, ansible.builtin.password_hash depends on passlib. 
The crypt is used as a fallback if passlib is not installed.

New in version 2.7.

Some hash types allow providing a rounds parameter:

    {{ 'secretpassword' | password_hash('sha256', 'mysecretsalt', rounds=10000) }}
    
# => "$5$rounds=10000$mysecretsalt$Tkm80llAxD4YHll6AgNIztKn0vzAACsuuEfYeGP7tm7"

The filter password_hash produces different results depending on whether you installed passlib or not.

To ensure idempotency, specify rounds to be neither crypt’s nor passlib’s default, which is 5000 for crypt and a variable value (535000 for sha256, 656000 for sha512) for passlib:

    {{ 'secretpassword' | password_hash('sha256', 'mysecretsalt', rounds=5001) }}
    
# => "$5$rounds=5001$mysecretsalt$wXcTWWXbfcR8er5IVf7NuquLvnUA6s8/qdtOhAZ.xN."

Hash type ‘blowfish’ (BCrypt) provides the facility to specify the version of the BCrypt algorithm.

    {{ 'secretpassword' | password_hash('blowfish', '1234567890123456789012', ident='2b') }}
    
# => "$2b$12$123456789012345678901uuJ4qFdej6xnWjOQT.FStqfdoY8dYUPC"

***Note***

The parameter is only available for blowfish (BCrypt). Other hash types will simply ignore this parameter. Valid values for this parameter are: [‘2’, ‘2a’, ‘2y’, ‘2b’]

New in version 2.12.

You can also use the Ansible ansible.builtin.vault filter to encrypt data:

    # simply encrypt my key in a vault
    vars:
      myvaultedkey: "{{ keyrawdata|vault(passphrase) }}"
      
    - name: save templated vaulted data
      template: src=dump_template_data.j2 dest=/some/key/vault.txt
      vars:
        mysalt: '{{ 2**256|random(seed=inventory_hostname) }}'
        template_data: '{{ secretdata|vault(vaultsecret, salt=mysalt) }}'
        
And then decrypt it using the unvault filter:

    # simply decrypt my key from a vault
    vars:
      mykey: "{{ myvaultedkey|unvault(passphrase) }}"
      
    - name: save templated unvaulted data
      template: src=dump_template_data.j2 dest=/some/key/clear.txt
      vars:
        template_data: '{{ secretdata|unvault(vaultsecret) }}'        