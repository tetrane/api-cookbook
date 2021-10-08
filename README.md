REVEN API Cookbook
==================

[Rendered Cookbook](https://tetrane.gitlab.io/reven/api-cookbook)

## Building the cookbook

```
mdboook build
```

## Serving the cookbook while modifying it

```
mdbook serve
```

## Using bulma in code

[Bulma 0.9.3](https://bulma.io) is available in md files. Just use HTML syntax.

## Generating the bulma.css file

The `bulma.css` file has been generated with the following command:

```bash
sass-rs < main.scss > bulma.css
```

from the root directory. Other sass generators can also be used.
