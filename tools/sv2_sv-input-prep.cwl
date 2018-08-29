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
      && /seq_cache_populate.pl
      -root $PWD/ref_cache
      $(inputs.reference.path)
      && export REF_CACHE=$PWD/ref_cache/%2s/%2s/%s
      && cp /usr/local/lib/python2.7/dist-packages/sv2/config/sv2.ini ./
      && sv2 -hg38 $(inputs.reference.path) -ini ./sv2.ini
      && sed -i "s,sv2_resource = None,sv2_resource = $PWD," ./sv2.ini

inputs:
  sv2_ref: File
  reference: {type: File, secondaryFiles: [.fai]}

outputs:
  output:
    type: string
    outputEval:
      valueFrom: >-
        $PWD

