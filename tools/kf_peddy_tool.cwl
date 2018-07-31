cwlVersion: v1.0
class: CommandLineTool
id: kf-peddy-tool
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 1000
  - class: DockerRequirement
    dockerPull: 'kfdrc/peddy:latest'
baseCommand: [python]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -m peddy
      -p 4
      --sites hg38
      --prefix $(inputs.output_basename)
      --plot
      $(inputs.vqsr_vcf.path)
      $(inputs.ped.path)

inputs:
  vqsr_vcf: {type: File, secondaryFiles: [.tbi]}
  ped: File
  output_basename: string
outputs:
  output:
    type: File
    outputBinding:
      glob: '*.html'
    secondaryFiles: [.tbi, .ped, .csv, .png, .json]
