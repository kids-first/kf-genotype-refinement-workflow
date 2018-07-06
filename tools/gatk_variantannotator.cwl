cwlVersion: v1.0
class: CommandLineTool
id: gatk_variantannotator
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
  - class: DockerRequirement
    dockerPull: 'kfdrc/gatk:3.8_ubuntu'
baseCommand: [java]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -Xms8000m
      -XX:GCTimeLimit=50
      -XX:GCHeapFreeLimit=10
      -jar /GenomeAnalysisTK.jar
      -T VariantAnnotator
      -R $(inputs.reference.path)
      -o $(inputs.output_basename).postCGP.Gfiltered.deNovos.vcf.gz
      -V $(inputs.cgp_filtered_vcf.path)
      -A PossibleDeNovo
      -ped $(inputs.ped.path)
      --pedigreeValidationType SILENT

inputs:
  reference: {type: File, secondaryFiles: [^.dict, .fai]}
  snp_sites: {type: File, secondaryFiles: [.tbi]}
  cgp_filtered_vcf: {type: File, secondaryFiles: [.tbi]}
  ped: File
  output_basename: string
outputs:
  output:
    type: File
    outputBinding:
      glob: '*.vcf.gz'
    secondaryFiles: [.tbi]
