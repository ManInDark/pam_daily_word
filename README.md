# pam_daily_word

This is a test project to play around with pam provider and consumer, it is currently destined to work like the wordle game, with daily rotating words you have to guess.

## Installation

```shell
echo deb http://manindark.github.io/pam_daily_word/debian bookworm main | sudo tee /etc/apt/sources.list.d/pam_daily_word.list
sudo wget -O /etc/apt/trusted.gpg.d/pam_daily_word.gpg https://manindark.github.io/pam_daily_word/key.gpg
sudo apt update
sudo apt install libpam-daily-word
```

Alternatively, if you use the newer apt-sources configuration, you can skip the first command and put the following content into `/etc/apt/sources.list.d/pam_daily_word.sources`.

```
Types: deb
URIs: http://manindark.github.io/pam_daily_word/debian/
Suites: bookworm
Components: main
Signed-By: /etc/apt/trusted.gpg.d/pam_daily_word.gpg
```
