cwlVersion: v1.0
class: CommandLineTool
id: sv2-sv-input-prep
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 1000
  - class: DockerRequirement
    dockerPull: 'sv2:latest'
baseCommand: [ tar, -xzf ]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.sv2_ref.path)
      && tar -xzf $(inputs.ref_cache.path)
      && /seq_cache_populate.pl
      -root $PWD/ref_cache
      $(inputs.reference.path)
      && export REF_CACHE=$PWD/ref_cache/%2s/%2s/%s
      && sv2 -hg38 $(inputs.reference.path)
      && sed -i "s,sv2_resource = None,sv2_resource = $PWD,"

inputs:
  sv2_ref: File
  reference: {type: File, secondaryFiles: [.fai]}
  ref_cache: File

outputs:
  output:
    type: ["null", "int"]
