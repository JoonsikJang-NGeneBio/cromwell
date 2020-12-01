class: CommandLineTool
cwlVersion: v1.0
hints:
  DockerRequirement:
    dockerPull: "marketplace.gcr.io/google/ubuntu1804:latest"
requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - "function foo() { return 2; }"
inputs: []
outputs:
  out: stdout
arguments: [echo, $(foo())]
stdout: whatever.txt
