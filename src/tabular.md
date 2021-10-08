# Exporting tabular data to work with reporting tools

## Pre-requisites: install pandas

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.5.0</span>
    </div>
  </div>
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Environment</span>
      <span class="tag is-info">Jupyter</span>
    </div>
  </div>
</div>
</div>

This example requires the `pandas` Python package:

```py
# From a code cell of a Jupyter notebook
try:
    import pandas
    print("pandas already installed")
except ImportError:
    print("Could not find pandas, attempting to install it from pip")
    import sys

    output = !{sys.executable} -m pip install pandas; echo $?  # noqa
    success = output[-1]

    for line in output[0:-1]:
        print(line)

    if int(success) != 0:
        raise RuntimeError("Error installing pandas")
    import pandas
    print("Successfully installed pandas")
```

## Building tabular data from filters

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.10.0</span>
    </div>
  </div>
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Dependency</span>
      <span class="tag is-info">pandas</span>
    </div>
  </div>
</div>
</div>

```py
res = []

header = ["Context range", "Process", "Location"]

processes = list(server.ossi.executed_processes("chat"))
for ctx_range in server.trace.filter(processes, reven2.filter.RingPolicy.R3Only):
    first_context = next(iter(ctx_range))
    res.append((ctx_range,
                first_context.ossi.process(),
                first_context.ossi.location()))

df = pandas.DataFrame.from_records(res, columns=header)
```

## Displaying tabular data in a Jupyter notebook

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.10.0</span>
    </div>
  </div>
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Environment</span>
      <span class="tag is-info">Jupyter</span>
    </div>
  </div>
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Dependency</span>
      <span class="tag is-info">pandas</span>
    </div>
  </div>
</div>
</div>

```py
res = []

header = ["Context range", "Process", "Location"]

processes = list(server.ossi.executed_processes("chat"))
for ctx_range in server.trace.filter(processes, reven2.filter.RingPolicy.R3Only):
    first_context = next(iter(ctx_range))
    res.append((ctx_range,
                first_context.ossi.process(),
                first_context.ossi.location()))

df = pandas.DataFrame.from_records(res, columns=header)

# display table truncated in the middle
display(df)
```

Sample output:

![Jupyter rendered table](img/jupyter_pandas.png)

## Exporting tabular data to csv

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.10.0</span>
    </div>
  </div>
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Dependency</span>
      <span class="tag is-info">pandas</span>
    </div>
  </div>
</div>
</div>

```py
df.to_csv("data.csv")
```

This can then be opened in e.g. spreadsheet software:

![Spreadsheet](img/calc_pandas.png)
