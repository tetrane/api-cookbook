{% import "templates/bulma.tera" as bulma %}

# Connecting to a server


{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="Server variable", class="is-info") }}
<p>
    The other examples of this book assume that your Python environment contains a <code>server</code> variable that represents a connection to a Reven server.
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}

## From its host and port

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.0.0"),
]) }}
{{ bulma::end_bulma() }}

```py
# Connecting to a reven server
hostname = "localhost"
port = 13370
server = reven2.RevenServer(hostname, port)
```

## From the scenario's name

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.3.0"),
  bulma::info_tag(name="Edition", value="Enterprise"),
  bulma::preview_tag(),
]) }}
{{ bulma::end_bulma() }}

You can use a feature of the Workflow API to get a connection to a server from the scenario's name, rather than by specifying a port.

From the CLI:

```py
from reven2.preview.project_manager import ProjectManager
pm = ProjectManager("http://localhost:8880")  # URL to the Reven Project Manager
connection = pm.connect("cve-2016-7255")  # No need to specify "13370"
server = connection.server
```

From a script:

```py
with pm.connect("cve-2016-7255") as server:
    # TODO: use the server
    pass
```

This is useful, as the server port will typically change at each reopening of the scenario, while the scenario name remains the same.

If no server is open for that particular scenario when executing the `ProjectManager.connect` method call, then a new one will be started.

# Checking server information

## Getting basic server information

```py
print(f"Scenario '{server.scenario_name}' on {server.host}:{server.port}")
```

Sample output:

```
Scenario 'CVE-2021-21166-Chrome' on localhost:13370
```

## Server OS information

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.12.0"),
  bulma::windows_tag(),
  bulma::linux_tag(),
]) }}
{{ bulma::end_bulma() }}

Starting with Reven 2.12, the server provides information on the OS of the running scenario:

```py
print(server.ossi.os())
```

Sample output:

```
Windows x64 10.0 (Windows 10)
```

### Checking that we are on the supported perimeter of the current script

```py
server.ossi.os().expect(reven2.ossi.Os(windows_version=reven2.ossi.WindowsVersion.Windows7),
                        reven2.ossi.Os(windows_version=reven2.ossi.WindowsVersion.Windows8))
```

Sample output:

```
reven2.ossi.os.OsError: Got 'Windows x64 10.0.18362 (Windows 10)', expected one of: 'Windows 7', 'Windows 8'
```

### Doing something different depending on the OS

```py
os = server.ossi.os()
os.expect(reven2.ossi.Os(family=reven2.ossi.OsFamily.Linux))
if os.kernel_version.major == 4:
   # do something with a kernel 4.x
   pass
elif os.kernel_version.major == 5:
   # do something with a kernel 5.x
   pass
else:
   raise reven2.ossi.OsError(got=os, message="Expected kernel major version 4 or 5")
```
