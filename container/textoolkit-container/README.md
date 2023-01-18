# TeX Toolkit Container Image

A container image, which contains a lot of useful tools for doing latex things.
The primary intention for this image is to run in CI and build/check latex
documents. Initially it started out as a container for the textidote linter,
but more tools accumulated. So now there is:

Two TeX distributions:

* texlive-full (from Ubuntu's repository with latexmk)
* tectonic

And some tools for linting/checking latex documents:

* LanguageTool
* Textidote
* bibclean
* redpen
* chktex
* lacheck

And some other useful misc things like

* pandoc
* git-latexdiff
* arxiv cleaning tools
    * arxiv-latex-cleaner
    * arxiv-collector
* ...


## Gitlab CI 

Drop the following into your `.gitlab-ci.yml` file:

```
include:
  - project: 'path/to/textoolkit-container'
    file: '/default-gitlab-ci.yml'
    
build-and-check:
  extends: .default-build-and-check
```

## Configure default CI job

In case you use a different filename or directory you can configure the default
CI job by overriding the default variables:

```
include:
  - project: 'path/to/textoolkit-container'
    file: '/default-gitlab-ci.yml'
    
build-and-check:
  extends: .default-build-and-check
  variables:
    USE_TECTONIC: "0"
    CD_TO_DIR: "."
    MAIN_TEX: "main.tex"
    LANGUAGE: "en"
```

## Interesting CI Job Templates

* Build the PDF
  ```yaml
  job:
    extends: .default-build
  ```
* Use default checkers (e.g. spellcheck)
  ```yaml
  job:
    extends: .default-check
  ```
* Build the PDF and use default checkers (e.g. spellcheck)
  ```yaml
  job:
    extends: .default-build-and-check
  ```
* Build the PDF, use default checkers (e.g. spellcheck), and build a diff pdf to
  the previous commit highlighting your changes also in the PDF
  ```yaml
  job:
    extends: .default-build-check-changes
  ```
* Build the PDF, use default checkers (e.g. spellcheck), and build a diff pdf to
  a certain fixed revision.
  ```yaml
  job:
    extends: .default-build-check-diff
    variables:
      DIFF_TO_REF: "my-tag-or-branch
  ```

## Running a specific Tool in Gitlab CI

TODO

(meanwhile check out the `default-gitlab-ci.yml`)
