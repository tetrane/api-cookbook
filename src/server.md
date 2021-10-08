# Connecting to a server

<div class="bulma">
  <div class="message is-info">
     <div class="message-header">
         Server variable
     </div>
     <div class="message-body content">
         <p>
         The other examples of this book assume that your Python environment contains a <code>server</code> variable that represents a connection to a REVEN server.
         </p>
     </div>
  </div>
</div>

## From its host and port

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.0.0</span>
    </div>
  </div>

</div>
</div>

```py
# Connecting to a reven server
hostname = "localhost"
port = 13370
server = reven2.RevenServer(hostname, port)
```

## From the scenario's name

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.3.0</span>
    </div>
  </div>

  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Edition</span>
      <span class="tag is-info">Enterprise</span>
    </div>
  </div>

  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">API</span>
      <span class="tag is-warning">preview</span>
    </div>
  </div>

</div>
</div>

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
