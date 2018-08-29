class: Workflow
cwlVersion: v1.0
id: kf-sv2-sv-genotyper
requirements:
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  sv2_ref: File
  reference: { type: File, secondaryFiles: [.fai] }
  ref_cache: File
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

outputs:
  cgp_vcf: {type: File, outputSource: gatk_calculategenotypeposteriors/output}
  cgp_filtered_vcf: {type: File, outputSource: gatk_variantfiltration/output}
  cgp_filtered_denovo_vcf: {type: File, outputSource: gatk_variantannotator/output}
steps:
  input_prep:
    in:
      sv2_ref: sv2_ref
      reference: reference
      ref_cache: ref_cache
    out: [output]
    run: ../tools/sv2_sv-input-prep.cwl.cwl
  sv2_runner:
    in:
      input_cram: input_cram
      sv_vcf: sv_vcf
      snv_vcf: snv_vcf
      ped: ped
    out: [output]
    run: ../tools/sv2_sv-runner.cwl
$namespaces:
  sbg: https://sevenbridges.com

