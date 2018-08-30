cwlVersion: v1.0
class: CommandLineTool
id: kf-sv2-sv-tool
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 3000
  - class: DockerRequirement
    dockerPull: 'sv2:latest'
  - class: MultipleInputFeatureRequirement
arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      tar -xzf $(inputs.sv2_ref.path)
      && /seq_cache_populate.pl
      -root $PWD/ref_cache
      $(inputs.reference.path)
      && export REF_CACHE=$PWD/ref_cache/%2s/%2s/%s
      && cp /usr/local/lib/python2.7/dist-packages/sv2/config/sv2.ini ./
      && sed -i "s,sv2_resource = None,sv2_resource = $PWD," ./sv2.ini
      && sed -i "s,hg38 = None,hg38 = $(inputs.reference.path)," ./sv2.ini
      && cp /usr/local/lib/python2.7/dist-packages/sv2/resources/training_sets/*.pkl .
      && sv2 -snv $(inputs.snv_vcf.path) -p $(inputs.ped.path) -g hg38 -ini ./sv2.ini
  - position: 2
    shellQuote: false
    valueFrom: >-
      && mv sv2_genotypes/sv2_genotypes.vcf $(inputs.output_basename)_sv2_genotypes.vcf
      && bgzip -i $(inputs.output_basename)_sv2_genotypes.vcf
      && mv sv2_genotypes/sv2_genotypes.txt $(inputs.output_basename)_sv2_genotypes.txt
inputs:
  reference: { type: File, secondaryFiles: [.fai] }
  input_cram:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -i
        itemSeparator: " "
        separate: true
        position: 1
    secondaryFiles:
      - .crai
  sv_vcf:
    type:
      type: array
      items: File
      inputBinding:
        prefix: -v
        itemSeparator: " "
        separate: true
        position: 1
    secondaryFiles:
      - .tbi
  snv_vcf: { type: File, secondaryFiles: [.tbi] }
  ped: File
  output_basename: string
  sv2_ref: File

outputs:
  out_vcf:
    type: File
    outputBinding:
      glob: '*.vcf.gz'
    secondaryFiles: [.tbi]
  out_txt:
    type: File
    outputBinding:
      glob: '*.txt'
