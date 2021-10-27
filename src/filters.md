{% import "templates/bulma.tera" as bulma %}

# Focusing on a portion of the trace

## Filtering on processes/ring

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.10.0"),
]) }}

```py
processes = list(server.ossi.executed_processes("chat"))
for ctx_range in server.trace.filter(processes, reven2.filter.RingPolicy.R3Only):
    first_context = next(iter(ctx_range))
    print(f"{ctx_range}: {first_context.ossi.process()}\t| {first_context.ossi.location()}")
```

Sample output:

```
[Context before #5662909, Context before #5669296]: chat_client.exe (2816)	| ntdll!ZwDeviceIoControlFile+0x14
[Context before #5670173, Context before #5671124]: chat_client.exe (2816)	| ntdll!NtSetIoCompletion+0x14
[Context before #5672523, Context before #5673027]: chat_client.exe (2816)	| ntdll!NtRemoveIoCompletionEx+0x14
[Context before #5678502, Context before #5678522]: chat_client.exe (2816)	| chat_client!<tokio_timer::clock::clock::Clock as tokio_timer::timer::now::Now>::now+0x24
[Context before #5678723, Context before #5679392]: chat_client.exe (2816)	| ntdll!ZwQueryPerformanceCounter+0x14
...
```
