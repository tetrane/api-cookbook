{% import "templates/bulma.tera" as bulma %}

# REVEN API Cookbook

Welcome to the REVEN API Cookbook.

This book is a collection of examples that demonstrate good practices to accomplish common tasks using the REVEN API.

{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="Pre-requisites", class="is-info") }}
<p>
    This book assumes that you already read the <a href="{{ user_doc_root }}/Python-API/Quickstart.html">Python API quick start guide</a>.
</p>
<p>
    Furthermore, all the examples of this book assume that you are in an environment where you can <code>import reven2</code> successfully.
    <br/>
    If this is not the case, please refer to the <a href="{{ user_doc_root }}/Python-API/Installation.html">installation documentation</a> of the Python API before starting this guide.
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}

## Common abbreviations and variable names

REVEN scripts tend to re-use the same abbreviations and variable names for common objects.

|Abbreviation|Description|
|------------|-----------|
|`server`|A `reven2.RevenServer` instance representing a connection to a REVEN server|
|`pm`|A `reven2.preview.project_manager.ProjectManager` instance representing a connection to the Project Manager|
|`trace`|A `reven2.trace.Trace` instance, usually obtained from `server.trace`|
|`tr`|A `reven2.trace.Transition` instance, usually obtained from `trace.transition(tr_id)`|
|`ctx`|A `reven2.trace.Context` instance, usually obtained from e.g. `trace.context_before(tr_id)`|
