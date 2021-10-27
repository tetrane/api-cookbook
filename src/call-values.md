{% import "templates/bulma.tera" as bulma %}

# Displaying the value of arguments and return value of a call

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.10.0"),
  bulma::preview_tag(),
  bulma::windows_tag(),
  bulma::linux_tag(),
]) }}

{% set ltrace = bulma::link(name="ltrace", url="https://github.com/tetrane/reven2-ltrace") %}
{% set file_activity = bulma::link(name="File activity", url="https://github.com/tetrane/reven2-file-activity") %}
{{ bulma::related_examples(examples=[
  "(GitHub)" ~ ltrace,
  "(GitHub)" ~ file_activity,
]) }}
{{ bulma::end_bulma() }}
## When the prototype is known

### Windows 64-bit

Use the `Ms64` calling convention.

```py
call_tr = tr.step_out(is_forward=False)
import reven2.preview.prototypes
prototypes = reven2.preview.prototypes.RevenPrototypes(server)
call_conv = prototypes.calling_conventions.Ms64
prototype = "char * __cdecl OaGetEnv(char const *)"
f = prototypes.parse_one_function(prototype, call_conv)
call = f.call_site_values(call_tr)
call.arg_n(0)
call.ret()
```

Sample output:

```py
'OACACHEPARAMS'
0
```

### Linux 64-bit

Use the `Sysv64` calling convention.

```py
call_tr = tr.step_out(is_forward=False)
import reven2.preview.prototypes
prototypes = reven2.preview.prototypes.RevenPrototypes(server)
call_conv = prototypes.calling_conventions.Sysv64
prototype = "struct FILE; FILE* fopen64(const char *filename, const char *mode);"
f = prototypes.parse_one_function(prototype, call_conv)
call = f.call_site_values(call_tr)
call.args()
call.ret()
```

Sample output:

```py
{'filename': '/proc/spl/kstat/zfs/arcstats', 'mode': 'r'}
0
```

## Using a default prototype

Example with 5 parameters.

```py
call_tr = tr.step_out(is_forward=False)
import reven2.preview.prototypes
prototypes = reven2.preview.prototypes.RevenPrototypes(server)
call_conv = prototypes.calling_conventions.Ms64
prototype = "void* f(void* p0, void* p1, void* p2, void* p3, void* p4);"
f = prototypes.parse_one_function(prototype, call_conv)
call = f.call_site_values(call_tr)
call.args()
call.ret()
```

Sample output:

```py
{'p0': 18446735287469384880,
 'p1': 0,
 'p2': 18446735287473289024,
 'p3': 0,
 'p4': 0}
1364968393473
```


{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="Limitations apply", class="is-warning") }}
<p>
    Using a default prototype works as long as the replaced parameters behave as <code>void*</code>.
</p>
<p>
    This is notably not the case for structs passed by value that are larger than a pointer (in some calling conventions) and for floating-point arguments (in Sysv64).
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}
