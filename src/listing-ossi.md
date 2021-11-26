{% import "templates/bulma.tera" as bulma %}

# Listing the processes, binaries in the trace

## Listing the processes executed in the trace

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.10.0"),
  bulma::windows_tag(),
]) }}
{{ bulma::end_bulma() }}


```py
for process in server.ossi.executed_processes():
    print(process)
```

Sample output:

```
cmd.exe (2320)
chat_client.exe (2832)
conhost.exe (2704)
cmd.exe (2716)
ShellExperienceHost.exe (2044)
svchost.exe (876)
conhost.exe (2596)
...
```

## Listing the binaries executed in the trace


{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
]) }}
{{ bulma::end_bulma() }}


```py
for binary in server.ossi.executed_binaries():
   print(binary)
```

Sample output:

```
c:/windows/system32/wevtsvc.dll
c:/windows/system32/oleacc.dll
c:/windows/system32/inputswitch.dll
c:/windows/explorer.exe
c:/windows/system32/ci.dll
c:/windows/system32/drivers/pciidex.sys
c:/windows/system32/drivers/intelide.sys
```

## Finding a single binary in the trace

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
]) }}
{{ bulma::end_bulma() }}

```py
def find_one_binary(binary_path):
    """
    Return the binary corresponding to the passed portion of its path if any,
    None if there isn't one, and throws if there would be two matches or more.
    """
    query = server.ossi.executed_binaries(binary_path)
    try:
        first = next(query)
    except StopIteration:
        return None
    try:
        second = next(query)
        raise ValueError(f"Found multiple binaries '{first}' and '{second}' for query '{binary_path}'")
    except StopIteration:
        return first
```

## Finding the base address where a binary has been loaded

Because a binary can be loaded multiple times at different addresses in a trace, we recover the base address from a Context where the binary is executed.
### Finding the base address of the first instance of a binary in the trace

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.2.0"),
]) }}
{{ bulma::end_bulma() }}

```py
def find_first_base_address(binary: reven2.ossi.ossi.Binary):
    for ctx in server.trace.search.binary(binary):
        return ctx.ossi.location().base_address
```

### Finding all the base addresses of a binary in a specified process

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.10.0"),
]) }}
{{ bulma::end_bulma() }}

```py
def find_base_address_in_process(binary: reven2.ossi.ossi.Binary, process: reven2.ossi.process.Process):
    for ctx_range in server.trace.filter(processes=(process,)):
        for ctx in server.trace.search.binary(binary, ctx_range.begin, ctx_range.end):
            return ctx.ossi.location().base_address
```
