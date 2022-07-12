# About

This image runs [imapfilter](https://github.com/lefcha/imapfilter), a tool for email filtering. It serves similar
purposes as [Sieve](http://sieve.info/), but no server-side support is required.

NOTE: Originally based on a fork of <https://github.com/eikendev/imapfilter-docker>

## Running the image

Create a directory to put your `imapfilter` config in. Since the configuration might have passwords, you should apply
appropriate permissions on it restricting it to a specific uid.

```shell-session
$ docker run  --rm --init  --user 1025:1025  --name=imapfilter \
              -v /etc/imapfilter:/config \
              -e IMAPFILTER_CONFIG=/config/config.lua \
              ghcr.io/sandipb/imapfilter
Running: /usr/bin/imapfilter -c /config/config.lua
...
```

The behavior of `imapfilter` can be customized by setting the following environment variables:

- `IMAPFILTER_CONFIG_DIR`: If this is provided and `IMAPFILTER_CONFIG` is not provided, then `imapfilter` will look for
  the config file `${IMAPFILTER_CONFIG_DIR}/.imapfilter/config.lua`. This will also set the environment variable
  `IMAPFILTER_HOME` to this value.
- `IMAPFILTER_CONFIG`: Path to the config file. Usually this is the minimum environment variable you need to set. Make
  sure this path is readable by the userid the docker runs with (default `2000:2000`)
- `IMAPFILTER_VERBOSE`: Adds `-v` parameter to `imapfilter` causing the imap protocol details to be dumped to stdout.
- `IMAPFILTER_DEBUG_FILE`: Path to a file where debug information will be dumped. Adds the `-d DEBUGFILE` parameter to
  `imapfilter` invocation.
- `IMAPFILTER_DRY_RUN`: Run `imapfilter` in dry-run mode (parameter `-n`).
- `IMAPFILTER_LOG_DIR`: Path to a directory where the `imapfilter` process will write its stdout and stderr output.
  Specifically, in `${IMAPFILTER_LOG_DIR}/imapfilter-stdout.log` and `${IMAPFILTER_LOG_DIR}/imapfilter-errors.log`
  respectively.
- `IMAPFILTER_EXTRA_ARGS`: Any extra parameters that you would like to add to the `imapfilter` invocation.
