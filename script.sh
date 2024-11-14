# exports previously generated key in format fitting for github secrets
gpg --armor --export-secret-keys 'manindark@own.manindark.me' | tr '\n' '|' > export.asc
