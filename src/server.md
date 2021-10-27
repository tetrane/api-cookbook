{% import "templates/bulma.tera" as bulma %}

# Connecting to a server


{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="Server variable", class="is-info") }}
<p>
    The other examples of this book assume that your Python environment contains a <code>server</code> variable that represents a connection to a REVEN server.
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
pm = ProjectManager("http://localhost:8880")  # URL to the REVEN Project Manager
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
