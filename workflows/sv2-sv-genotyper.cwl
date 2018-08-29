class: Workflow
cwlVersion: v1.0
id: kf-sv2-sv-genotyper
requirements:
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  sv2_ref: File
  reference: { type: File, secondaryFiles: [.fai] }
  input_cram:
    type:
      type: array
      items: File
      secondaryFiles:
        - .crai
  sv_vcf:
    type:
      type: array
      items: File
    secondaryFiles:
      - .tbi
  snv_vcf: { type: File, secondaryFiles: [.tbi] }
  ped: File
  output_basename: string

outputs:
  out_vcf: { type: File, outputSource: sv2_runner/out_vcf }
  out_txt: { type: File, outputSource: sv2_runner/out_txt }
steps:
  input_prep:
    in:
      sv2_ref: sv2_ref
      reference: reference
    out: [output]
    run: ../tools/sv2_sv-input-prep.cwl
  sv2_runner:
    in:
      input_cram: input_cram
      sv_vcf: sv_vcf
      snv_vcf: snv_vcf
      ped: ped
      output_basename: output_basename
      ini_loc: input_prep/ini_loc
      cache_loc: input_prep/cache_loc
    out: [output]
    run: ../tools/sv2_sv-runner.cwl
$namespaces:
  sbg: https://sevenbridges.com

