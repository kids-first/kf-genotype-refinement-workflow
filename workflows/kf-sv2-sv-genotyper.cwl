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
  out_vcf: { type: File, outputSource: sv2-sv-runner/out_vcf }
  out_txt: { type: File, outputSource: sv2-sv-runner/out_txt }
steps:
  sv2-sv-input-prep:
    run: ../tools/sv2_sv-input-prep.cwl
    in:
      sv2_ref: sv2_ref
      reference: reference
    out: [ini_loc, cache_loc]
  sv2-sv-runner:
    run: ../tools/sv2_sv-runner.cwl
    in:
      input_cram: input_cram
      sv_vcf: sv_vcf
      snv_vcf: snv_vcf
      ped: ped
      output_basename: output_basename
      ini_loc: sv2-sv-input-prep/ini_loc
      cache_loc: sv2-sv-input-prep/cache_loc
    out: [out_vcf, out_txt]
$namespaces:
  sbg: https://sevenbridges.com

