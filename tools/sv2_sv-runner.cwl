cwlVersion: v1.0
class: CommandLineTool
id: sv2-sv-runner
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 3000
  - class: DockerRequirement
    dockerPull: 'sv2:latest'
baseCommand: [ sv2 ]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -snv $(inputs.snv_vcf.path) -p $(inputs.ped.path) -g hg38
      && mv sv2_genotypes/sv2_genotypes.vcf $(inputs.output_basename)_sv2_genotypes.vcf
      && bgzip -i $(inputs.output_basename)_sv2_genotypes.vcf
      && mv sv2_genotypes/sv2_genotypes.txt $(inputs.output_basename)_sv2_genotypes.txt
inputs:
  input_cram:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -i
        itemSeparator: " "
        separate: false
    secondaryFiles:
      - .crai
  sv_vcf:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -v
        itemSeparator: " "
        separate: false
    secondaryFiles:
      - .tbi
  snv_vcf: { type: File, secondaryFiles: [.tbi] }
  ped: File
  output_basename: string

outputs:
  out_vcf:
    type: File
    outputBinding:
      glob: '*.vcf.gz'
    secondaryFiles:
      - .tbi
  out_txt:
    type: File
    outputBinding:
      glob: '*.txt'
