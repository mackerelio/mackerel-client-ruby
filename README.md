# Mackerel::Client

TODO: Write a gem description


# CLI

## Host

* Get host(s) information from hostname or service, role.
```
mkr host info [--name foo] [--service service] [--role role]
```

* Set status of a host
```
mkr host status --host-id foo --status working
```

* Retire a host
```
mkr host retire --host-id foo
```

* Get status of a host (not implemented yet)
```
mkr host status --host-id foo
```

## Authentication
```
export MACKEREL_APIKEY=foobar
```

## reference
* http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
* https://github.com/aws/aws-cli

