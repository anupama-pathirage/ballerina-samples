# pls refer https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository
name: 🐞 Bug Report 
description: File a bug report
title: "[Bug]: "
labels: [Type/Bug]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this bug report!
  - type: dropdown
    id: area-name
    attributes:
      label: Area Name
      description: Choose the Area you are reporting the bug against
      options:
        - Compiler
        - Runtime
        - Standard Library
        - Developer Tools (VSCode, Test Framework, Debugger, Central, Package API)
        - Language Support (LS, Compiler APIs)
        - Documentation (Web Site, API Docs, BBEs)
    validations:
      required: true
  - type: textarea
    id: description
    attributes:
      label: Description of the bug?
      description: Also tell us, what did you expect to happen?
      placeholder: Tell us what you see!
      value: "A bug happened!"
    validations:
      required: true
  - type: textarea
    id: logs
    attributes:
      label: Relevant log output
      description: Please copy and paste any relevant log output. This will be automatically formatted into code, so no need for backticks.
      render: shell
  - type: textarea
    id: version
    attributes:
      label: Ballerina Version or the component/module version
      description: Also tell us, any other valuable information.
      placeholder: Version and extra details!
      value: "Version: "
    validations:
      required: true      
