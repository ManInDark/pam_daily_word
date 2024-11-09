# pam_daily_word

This is a test project to play around with pam provider and consumer, it is currently destined to work like the wordle game, with daily rotating words you have to guess.

## Installation

```shell
echo deb http://manindark.github.io/pam_daily_word/debian bookworm main | sudo tee /etc/apt/sources.list.d/pam_daily_word.list
sudo wget -O /etc/apt/trusted.gpg.d/pam_daily_word.gpg https://manindark.github.io/pam_daily_word/key.gpg
sudo apt update
sudo apt install libpam-daily-word
```

This would be how to install the package, if github pages actually served `.deb` files, but it doesn't. To selfhost the repository you only need to serve the files in `repository` via http. This could for example be done with python:

```shell
python -m http.server 80
```