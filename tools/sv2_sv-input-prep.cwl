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
      && echo $PWD/ref_cache > cache_loc.txt
      && cp /usr/local/lib/python2.7/dist-packages/sv2/config/sv2.ini ./
      && sed -i "s,sv2_resource = None,sv2_resource = $PWD," ./sv2.ini
      && sed -i "s,hg38 = None,hg38 = $(inputs.reference.path)," ./sv2.ini
inputs:
  sv2_ref: File
  reference: {type: File, secondaryFiles: [.fai]}

outputs:
  ini_file:
    type: File
    outputBinding:
      glob: 'sv2.ini'
  cache_loc:
    type: File
    outputBinding:
      glob: 'cache_loc.txt'
      loadContents: True
