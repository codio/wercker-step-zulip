# zulip-notify

Send a message to an zulip room

## Options

### required

* `bot` - zulip bot auth.
* `domain` - zulip installation domain
* `stream` - stream to publish

### optional

* `on` - Possible values: `always` and `failed`, default `always`

## Example


Add `ZULIP_TOKEN` as deploy target or application environment variable.

```yml
build:
    after-steps:
        - zulip-notify:
            bot: wercker-bot@<domain>:key,
            domain: zulip_domain
            stream: announce
```
