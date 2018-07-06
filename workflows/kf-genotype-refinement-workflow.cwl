class: Workflow
cwlVersion: v1.0
id: kf_genotype_refinement_workflow
requirements:
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  ped: File
  reference: File
  snp_sites: File
  vqsr_vcf: File
  output_basename: string
outputs:
  cgp_vcf: {type: File, outputSource: gatk_calculategenotypeposteriors/output}
  cgp_filtered_vcf: {type: File, outputSource: gatk_variantfiltration/output}
  cgp_filtered_denovo_vcf: {type: File, outputSource: gatk_variantannotator/output}
steps:
  gatk_calculategenotypeposteriors:
    in:
      ped: ped
      reference: reference
      snp_sites: snp_sites
      vqsr_vcf: vqsr_vcf
      output_basename: output_basename
    out: [output]
    run: ../tools/gatk_calculategenotypeposteriors.cwl
  gatk_variantfiltration:
    in:
      cgp_vcf: gatk_calculategenotypeposteriors/output
      reference: reference
      output_basename: output_basename
    out: [output]
    run: ../tools/gatk_variantfiltration.cwl
  gatk_variantannotator:
    in:
      cgp_filtered_vcf: gatk_variantfiltration/output
      ped: ped
      reference: reference
      output_basename: output_basename
    out: [output]
    run: ../tools/gatk_variantannotator.cwl
$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:AWSInstanceType'
    value: m4.xlarge;ebs-gp2;80
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 2
