class: Workflow
cwlVersion: v1.0
id: kf_genotype_refinement_workflow
requirements:
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  - id: ped
    type: File
    'sbg:x': 0
    'sbg:y': 321
  - id: reference
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
  - id: snp_sites
    type: File
    secondaryFiles:
      - .tbi
  - id: vqsr_vcf
    type: File
    'sbg:x': 0
    'sbg:y': 0
    secondaryFiles:
      - .tbi
outputs:
  - id: cgp_vcf
    outputSource:
      - gatk_calculategenotypeposteriors/output
    type: File
    secondaryFiles:
      - .tbi
  - id: cgp_filtered_vcf
    outputSource:
      - gatk_variantfiltration/output
    type: File
    secondaryFiles:
      - .tbi
steps:
  - id: gatk_calculategenotypeposteriors
    in:
      - id: ped
        source: ped
      - id: reference
        source: reference
      - id: snp_sites
        source: snp_sites
      - id: vqsr_vcf
        source: vqsr_vcf
    out:
      - id: output
    run: ../tools/gatk_calculategenotypeposteriors.cwl
  - id: gatk_variantfiltration
    in:
      - id: cgp_vcf
        source: gatk_calculategenotypeposteriors/output
      - id: reference
        source: reference
      - id: snp_sites
        source: snp_sites
    out:
      - id: output
    run: ../tools/gatk_variantfiltration.cwl
  - id: gatk_variant_annotator
    in:
      - id: cgp_filtered_vcf
        source: gatk_variantfiltration/output
      - id: ped
        source: ped
      - id: reference
        source: reference
      - id: snp_sites
        source: snp_sites
    out:
      - id: output
    run: ../tools/gatk_variantannotator.cwl
$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:AWSInstanceType'
    value: c4.8xlarge;ebs-gp2;850
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 4
