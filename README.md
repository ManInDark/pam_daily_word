# pam_daily_word

This is a test project to play around with pam provider and consumer, it is currently destined to work like the wordle game, with daily rotating words you have to guess.

## Installation

Caution: the list is currently copied to `/tmp/list`, which is not persistent, so don't enable it for anything important, as it would fail without the file

```shell
make build link pamrule
```

## Testing

```shell
make test
```
