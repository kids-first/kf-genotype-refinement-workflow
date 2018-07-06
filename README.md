# kfdrc genotype refinement workflow
## basic info
- tool images: https://hub.docker.com/r/kfdrc/
- dockerfiles: https://github.com/d3b-center/bixtools
- tested with
  - rabix-v1.0.5: https://github.com/rabix/bunny/releases/tag/v1.0.5

## inputs:
```yaml
ped:
  class: File
  path: FM_XXXXXX.ped
reference:
  class: File
  path: Homo_sapiens_assembly38.fasta
snp_sites:
  class: File
  path: 1000G_phase3_v4_20130502.sites.hg38.vcf
vqsr_vcf:
  class: File
  path: vqsr_vcf.vcf.gz
output_basename: vqsr_vcf
```
